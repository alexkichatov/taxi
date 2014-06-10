//
//  TXHttpRequestManager.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/20/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXHttpRequestManager.h"
#import "StrConsts.h"
#import "Macro.h"
#import "utils.h"
#import "TXFileManager.h"
#import "TXApp.h"
#import "NSString+TXNSString.h"

static NSString* const HTTPAPI_PLIST_FILE = @"httpapi";
static NSString* const DEFAULT_CONFIG = @"register";
static NSString* const HDR_ACCEPT         = @"Accept";
static NSString* const HDR_CONTENTTYPE    = @"Content-Type";

@implementation TXSyncResponseDescriptor

@synthesize source, error, success;

-(NSString *)description {
    return [NSString stringWithFormat:@"success: %@, source: %@, error: %@", [NSNumber numberWithBool:self.success], source, error];
}

@end

@implementation TXRequestConfig

@synthesize name, url, httpMethod, headers, hasUrlBase, bodyTemplate;


+(TXRequestConfig *) configForName:(NSString*) name{
    
    NSDictionary* root = [[[TXApp instance] getSettings] getProperty:SettingsConst.Property.HTTP_API];
    
    if ( [root count] > 0 ) {
        
        if( [name length]==0 ) {
            name = DEFAULT_CONFIG;
        }
        
        TXRequestConfig *reqConfig = [[TXRequestConfig alloc] init];
        
        NSMutableDictionary *config = [root objectForKey:name];
        
        if ( config != nil ) {
            reqConfig.name = name;
            reqConfig.local = [[config objectForKey:@"local"] boolValue];
            reqConfig.headers = [config objectForKey:@"headers"];
            reqConfig.httpMethod = [config objectForKey:@"httpMethod"];
            reqConfig.url = [config objectForKey:@"url"];
            reqConfig.hasUrlBase = [[config objectForKey:@"hasUrlBase"] boolValue];
            reqConfig.bodyTemplate = [config objectForKey:@"bodyTemplate"];
            reqConfig.timeOut = [config objectForKey:@"timeOut"];
            return  reqConfig;
        }
    }
    
    DLogE(@"Invalid http api definitions file!");
    return nil;
}

@end

@interface TXRequestObj() {
    TXSettings *settings;
}
-(id) initWithConfig:(NSString *)config urlParams:(NSString *)urlParams_ listener:(id<TXHttpRequestListener>) listener_;
@end

@implementation TXRequestObj

@synthesize	reqUrl, receivedData, listener, target, reqConfig, body;

+(id) create:(NSString *)config urlParams:(NSString *)urlParams listener:(id<TXHttpRequestListener>) listener {
    
    if ( config.length == 0 ) {
        return nil;
    }
    
    return [[self alloc] initWithConfig:config urlParams:urlParams listener:listener];
    
}

-(id) initWithConfig:(NSString *)config urlParams:(NSString *)urlParams_ listener:(id<TXHttpRequestListener>) listener_ {
    
    if(self = [super init]) {
    
        self.listener = listener_;
        self.reqConfig = [TXRequestConfig configForName:config];
        self.urlParams = urlParams_;

        settings = [[TXApp instance] getSettings];
        
        if(self.reqConfig.hasUrlBase == YES) {
            self.baseURL = [NSString stringWithFormat:@"%@:%@", [settings getProperty:SettingsConst.Property.BASEURL], [settings getProperty:SettingsConst.Property.PORT]];
            self.reqUrl = [NSString stringWithFormat:@"%@%@", self.baseURL, self.reqConfig.url];
        } else {
            self.reqUrl = [NSString stringWithFormat:self.reqConfig.url, self.urlParams];
        }
        
        self.attemptCount = 0;
        
    }
    
    return self;
    
}

-(NSMutableURLRequest*)createHTTPRequest {
    
    TXRequestConfig* rqCfg = self.reqConfig;
    if ( rqCfg != nil )
	{
		NSURL* pathURL = [NSURL URLWithString:self.reqUrl];
        int timeOutSecs = rqCfg.timeOut != nil ? [rqCfg.timeOut intValue] : DEFTIMEOUT;
        NSMutableURLRequest *httpRequest = [[NSMutableURLRequest alloc] initWithURL: pathURL
                                                                        cachePolicy: NSURLRequestReloadIgnoringLocalCacheData
                                                                        timeoutInterval: timeOutSecs];
        
        [httpRequest setHTTPMethod: rqCfg.httpMethod];
        
        if ( rqCfg.headers != nil ) {
            
            NSEnumerator* e = [rqCfg.headers keyEnumerator];
            NSString* hdrField;
            while( (hdrField = [e nextObject]) )
            {
                NSString *value = [rqCfg.headers objectForKey:hdrField];
                
                if( [hdrField isEqualToString:@"Authorization"] && (value == nil || [value length] == 0) ) {
                    value = [NSString stringWithFormat:@"%@:%@", [self->settings getUserName], [self->settings getPassword]];
                    value = [NSString stringWithFormat:@"Basic %@", base64String(value) ];
                }
                
                [httpRequest addValue:value forHTTPHeaderField:hdrField];
                
            }
        }
        
        //check if we have set Accept header field, if not set json as default
        NSString* accept = [httpRequest valueForHTTPHeaderField:HDR_ACCEPT];
        if ( accept == nil )
            [httpRequest addValue:@"application/json" forHTTPHeaderField:HDR_ACCEPT];
        
        if ([rqCfg.httpMethod isEqualToString:@"POST"])
        {
            NSMutableData *postBody = [NSMutableData data];
            
            if ( self.body && [self.body length] > 0)
            {
                [postBody appendData:  [self.body dataUsingEncoding:NSUTF8StringEncoding] ];
            }
            
            //default content type to json if it wasn't set by headers already
            NSString* ctype = [httpRequest valueForHTTPHeaderField:HDR_CONTENTTYPE];
            if ( ctype == nil )
                [httpRequest addValue:@"application/json" forHTTPHeaderField:HDR_CONTENTTYPE];
            
            if ([postBody length] > 0)
            {
                NSString *rLen = [NSString stringWithFormat:@"%d", [postBody length]];
                [httpRequest addValue:rLen forHTTPHeaderField:@"Content-Length"];
                
                [httpRequest setHTTPBody:postBody];
            }
        } 
        
        return httpRequest;
    }
    
    return nil;
}

@end

@interface TXHttpRequestManager() {
    NSArray*            trustedHosts;
}

-(TXRequestObj*)requestForConnection:(NSURLConnection*)connection;
+(NSString*)urlEncode:(NSString*)src;

@end

@implementation TXHttpRequestManager

/** creates the single instance within the application
 
 @return TXHttpRequestManager
 */
+(TXHttpRequestManager *) instance {
    static dispatch_once_t pred;
    static TXHttpRequestManager* _instance;
    dispatch_once(&pred, ^{ _instance = [[self alloc] init]; });
    return _instance;
}

-(id) init {
    
    self = [super init];
    if(self!=nil) {
        self->pendingRequests = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    
    return self;
}

-(TXRequestObj*)requestForConnection:(NSURLConnection*)connection {
    
    NSValue* connVal = [NSValue valueWithNonretainedObject:connection];
    return [self->pendingRequests objectForKey:connVal];
}

/**
 Encodes string correctly, including & and / unlike Apple's crappy encode
 **/
+(NSString*)urlEncode:(NSString*)src {
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)src, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", kCFStringEncodingUTF8));
}


-(TXSyncResponseDescriptor*)sendSyncRequest:(TXRequestObj*)request {
    
    TXSyncResponseDescriptor *result = nil;
    
    if ( request != nil )
	{
        result = [[TXSyncResponseDescriptor alloc] init];
        NSMutableURLRequest* httpRequest = [request createHTTPRequest];
		NSError* error_ = nil;
		NSURLResponse* response;
        
        request.attemptCount++;
		NSData* responseData = [NSURLConnection sendSynchronousRequest:httpRequest returningResponse:&response error:&error_];
        int responseStatusCode = [(NSHTTPURLResponse*)response statusCode];
        
		if ( [error_ code] || responseStatusCode != HTTP_OK )
		{
            NSString *msgFmt = @"HTTP %@ Error - Status Code %d\n %@ %d %@\nresponse data - %@\n for URL - %@\nrequest body:\n%@";
            NSString *message = [NSString stringWithFormat:msgFmt, request.reqConfig.httpMethod,responseStatusCode,[error_ domain], [error_ code],
                                 [error_ localizedDescription],
                                 [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding],
                                 request.reqUrl,
                                 request.body];
            
            DLogE(@"%@", message);
            
            result.error = [TXError error:TX_ERR_HTTP_REQUEST_FAILED message:[error_ domain] description:message];
            
		} else {
        
            request.receivedData = (NSMutableData*)responseData;
            NSMutableString *respStr_ = [[[NSString alloc] initWithData:request.receivedData encoding:NSUTF8StringEncoding] mutableCopy];
            NSString *respStr = [respStr_ stringByReplacingOccurrencesOfString:@"=" withString:@":"];
            NSLog(@"%@", respStr);
            
            NSDictionary* responseObj = getJSONObj(respStr);
            NSDictionary* source      = [responseObj objectForKey:@"source"];
            id successObj             = [responseObj objectForKey:@"success"];
            result.success            = successObj!=nil ? [successObj boolValue] : NO;
            result.source = source;
            
            if(result.success == YES) {
                result.code = 1000;
            } else {
                result.code = [[source objectForKey:@"code"] intValue];
            }
            
            NSLog(@"%@ Req To Url - %@ completed", request.reqConfig.httpMethod, request.reqUrl);

        }

	}
    
	return result;
    
}

-(void) cancelRequest:(TXRequestObj*)request {
    
    for ( NSValue *connection in [self->pendingRequests keyEnumerator] ) {
        TXRequestObj *creq = [self->pendingRequests objectForKey:connection];
        if ( request == creq ) {
            NSURLConnection* urlConn = [connection nonretainedObjectValue];
            [urlConn cancel];
            return;
        }
    }
}

-(void) cancelRequestsByName:(NSString*)requestName {
    for ( NSValue *connection in [self->pendingRequests keyEnumerator] ) {
        TXRequestObj *creq = [self->pendingRequests objectForKey:connection];
        if ( [creq.reqConfig.name isEqualToString:requestName] ) {
            NSURLConnection* urlConn = [connection nonretainedObjectValue];
            [urlConn cancel];
        }
    }
}

-(BOOL)sendAsyncRequest:(TXRequestObj*)request {
    
	if ( request != nil )
	{
		NSMutableURLRequest *httpRequest = [request createHTTPRequest];
        request.attemptCount++;
        
        if ( httpRequest != nil )
        {
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:httpRequest delegate:self startImmediately:YES];
            
            if ( conn == nil ) {
                return NO;
            }
            
            NSLog(@"Sent Async Request to URL - %@\n\nBody:\n%@", request.reqUrl, request.body );
            
            request.receivedData = [NSMutableData data];
            [self addPendingRequest:request withConnection:conn];
            return YES;
        }
	}
    
	return NO;
}

-(BOOL)uploadAttachmentAsync: (TXRequestObj *)request {
    return [self sendAsyncRequest:request];
}

-(BOOL)downloadAttachementAsync: (TXRequestObj *)request {
    return [self sendAsyncRequest:request];
}


-(void)addPendingRequest:(TXRequestObj*) request withConnection:(NSURLConnection*)connection{
    NSValue* connVal = [NSValue valueWithNonretainedObject:connection];
    [self->pendingRequests setObject:request forKey:connVal];
}

-(void)disposeRequestJob:(NSURLConnection*)connection {
    
    NSValue* connVal = [NSValue valueWithNonretainedObject:connection];
    
    DLogI(@"Removed request form pending list - %@", ((TXRequestObj*)[self->pendingRequests objectForKey:connVal]).reqUrl);
    
    [self->pendingRequests removeObjectForKey:connVal];
}

-(int)getPendingRequestCount {
    return [self->pendingRequests count];
}

#pragma mark delegate methods for nsurl connection

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError*)error {
    
    TXRequestObj* request = [self requestForConnection:connection];
	[self disposeRequestJob:connection];
    
	//log error here if the request had no error handler
	if ([error code] && request.listener == nil ) {
		DLogE(@"%@ - %@ %d %@", @"HTTP Get Error", [error domain], [error code], [ error localizedDescription]);
	} else if (request.listener!=nil) {
     	[request.listener onFail:request error:[TXError error:[error code] message:[error domain] description:[error localizedDescription]]];
	}
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
	int statusCode = [(NSHTTPURLResponse *)response statusCode];
	if (statusCode != HTTP_OK)
	{
        
        TXRequestObj* request = [self requestForConnection:connection];
        if( statusCode == HTTP_UNAUTHORIZED ) {
           
        }
        
        NSString* statusMsg	= [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
        
		if (request.listener == nil ) {
			DLogE(@"Async Req To Url - %@ received response with error: %@", request.reqUrl, statusMsg);
		}
		else {
            request.statusCode = statusCode;
            request.statusMsg = statusMsg;
            
			[request.listener onFail:request error:[TXError error:statusCode message:statusMsg description:[NSString stringWithFormat:@"AMDCHttpReqManager, didReceiveResponse, url: %@", request.reqUrl]]];
		}
        
		[connection cancel];
		[self disposeRequestJob:connection];
	}
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    TXRequestObj* request = [self requestForConnection:connection];
    [request.receivedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    TXRequestObj* request = [self requestForConnection:connection];
	[self disposeRequestJob:connection];
    
    DLogI(@"Async Req To Url - %@ received response from : %@", request.reqUrl, @"Success ...");
    
    if(request.listener!=nil) {
        [request.listener onRequestCompleted:request];
    }
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
		if ([trustedHosts containsObject:challenge.protectionSpace.host])
			[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
 			 willSendRequest:(NSURLRequest *)request
 			redirectResponse:(NSURLResponse *)redirectResponse {
 	return request;
}

@end
