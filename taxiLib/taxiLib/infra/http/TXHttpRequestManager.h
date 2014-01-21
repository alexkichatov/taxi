//
//  TXHttpRequestManager.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/20/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HTTP_OK             200
#define HTTP_UNAUTHORIZED   401
#define HTTP_NOTFOUND       404
#define HTTP_SERVER_ERROR	500

#define DEFTIMEOUT      60
#define DEFREFCOUNT     10

@class TXError;

@protocol TXHttpRequestListener <NSObject>

-(void) onRequestCompleted : (id) object;
-(void) onFail : (id) object error:(TXError*) error;

@end

/*!
 @interface AMDCReqConfig
 @discussion http request config object
 */
@interface TXRequestConfig : NSObject
{
@private
    NSString* name;
    NSString* url;
    NSString* httpMethod;
    NSDictionary* headers;
    BOOL     hasUrlBase;//if set to yes, download manager must skip prepending base url string.
    NSString *bodyTemplate;
}

/*!
 @property config name
 */
@property (nonatomic, strong) NSString*     name;

/*!
 @property request url
 */
@property (nonatomic, strong) NSString*     url;

/*!
 @property request method
 */
@property (nonatomic, strong) NSString*     httpMethod;

/*!
 @property http headers
 */
@property (nonatomic, strong) NSDictionary* headers;

/*!
 @property hasUrlBase, set to NO if request url already consists base url (full url), either YES and url is appended by base url prefix
 */
@property (nonatomic, assign) BOOL          hasUrlBase;

/*!
 @property bodyTemplate - format string used ot format actual request body json string
 
 */
@property (nonatomic, strong) NSString* bodyTemplate;

@property (nonatomic, strong) NSNumber* timeOut;

/*!
 @function configForName creates the instance of http request config object
 with the specified string parameter configName
 @param cfgName
 */
+(TXRequestConfig *) configForName:(NSString*) cfgName;

@end

@interface TXRequestObj : NSObject
{
	int                                                 expectedContLen;//set by response handler. Used by delegate
}


/*!
 @property baseURL host name + base path of the interface, loaded form setings
 */
@property (nonatomic, strong) NSString*                     baseURL;

/*!
 @property port port number for the url, loaded form setings
 */
@property (nonatomic, strong) NSString*                     port;

/*!
 @property reqUrl request url string which is base url + port + subpath of the current request
 */
@property (nonatomic, strong) NSString*                     reqUrl;

/*!
 @property receivedData response recieved data
 */
@property (nonatomic, strong) NSMutableData*                receivedData;

/*!
 @property request target object
 */
@property (nonatomic, strong) NSObject*                     target;

/*!
 @property reqConfig, config object for the request
 */
@property (nonatomic, strong) TXRequestConfig*                reqConfig;

/*!
 @property listener object where the event methods are invoked on async http requests if registered
 */
@property (nonatomic, strong) id<TXHttpRequestListener>   listener;

/*!
 @property request body
 */
@property (nonatomic, strong) NSString*     body;

/*!
 @property statusCode HTTP response status code
 */
@property (nonatomic, assign) int     statusCode;

/*!
 @property statusMsg response status msg
 */
@property (nonatomic, strong) NSString*     statusMsg;

/*!
 @property requestParameters additioonal parameters for the request
 */
@property (nonatomic, strong) NSDictionary*     requestParameters;

/*!
 @property attemptCount how many times did request manager attempt to perform this request
 */
@property (nonatomic, assign) int               attemptCount;

/*!
 @function initWithConfig creates the instance of http request object
 with the specified AMDCReqConfig object that is created according passed
 string parameter configName
 @param fileDownloadListener
 @param configName
 */
+(id) initWithConfig : (NSString *) configName andListener:(id<TXHttpRequestListener>) listener;

-(NSMutableURLRequest*)createHTTPRequest;

@end

@interface TXHttpRequestManager : NSObject
{
	NSString*				baseUrl;
	NSMutableDictionary*	pendingRequests;
    NSMutableDictionary*    requestConfigs;
    int                     defTimeout;
}

/*!
 @function instance creates the single instance within the application
 @return AMDCHttpReqManager
 */
+(TXHttpRequestManager *) instance;
/*!
 @function sendAsyncRequest sends the asynchronous http request
 @param request
 @return BOOL flag for the success or failure
 */
-(BOOL)sendAsyncRequest:(TXRequestObj*) request;

/*!
 @function sendSyncRequest sends the synchronous http request
 @param request
 @return BOOL flag for the success or failure
 */
-(id)sendSyncRequest:(TXRequestObj*)request;

/*!
 @function cancelRequest cancel http request corresponding to the AMDCReqObj given
 this must be the same object passed to the sendAsyncRequest function.
 @param request
 @return void
 */
-(void) cancelRequest:(TXRequestObj*)request;

/*!
 @function cancelRequestsByName cancel all http requests having the matching config name.
 @param requestName
 @return void
 */
-(void) cancelRequestsByName:(NSString*)requestName;

/*!
 @function uploadFileAsync uploads the file on the server asynchronously
 @param request
 @param file
 @return BOOL flag for the success or failure
 */
-(BOOL)uploadAttachmentAsync: (TXRequestObj *)request;

/*!
 @function downloadFileAsync downloads the file from the server asynchronously
 @param request
 @return BOOL flag for the success or failure
 */
-(BOOL)downloadAttachementAsync: (TXRequestObj *)request;

-(int)getPendingRequestCount;

@end


