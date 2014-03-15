//
//  TXModelBase.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXModelBase.h"
#import "taxiLib/utils.h"
#import "Types.h"

@implementation TXModelBase

-(id)init {
    
    if(self = [super init]) {
        self->httpMgr     = [TXHttpRequestManager instance];
        self->application = [TXVM instance];
    }
    
    return self;
}

-(void)onRequestCompleted:(id)object {
    
    TXEvent *event = nil;
    TXRequestObj *request = nil;
    
    if(object!=nil) {
    
        request                   = (TXRequestObj*)object;
        NSDictionary *responseObj = getJSONObj([[NSString alloc] initWithData:request.receivedData encoding:NSUTF8StringEncoding]);
        
        if(responseObj!=nil) {
        
            BOOL success = NO;
            NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithCapacity:2];
            
            id successVal = [responseObj objectForKey:API_JSON.Keys.SUCCESS];
            if(successVal!=nil) {
                success = [successVal boolValue];
                [properties setObject:[NSNumber numberWithBool:success] forKey:API_JSON.Keys.SUCCESS];
            }
            
            NSString *data = [responseObj objectForKey:API_JSON.Keys.DATA];
            
            if(data!=nil) {
                [properties setObject:data forKey:API_JSON.Keys.DATA];
            }
            
            event = [TXEvent createEvent:TXEvents.HTTPREQUESTCOMPLETED eventSource:self eventProps:properties];
            
        } else {
            
            event = [TXEvent createEvent:TXEvents.NULLHTTPRESPONSE eventSource:self eventProps:nil];
            
        }
        
    } else {

        event = [TXEvent createEvent:TXEvents.NULLHTTPREQUEST eventSource:self eventProps:nil];
        
    }
    
    
    [self fireEvent:event];
}

-(void)onFail:(id)object error:(TXError *)error {
    
    NSDictionary *properties  = @{ API_JSON.Keys.SUCCESS : [NSNumber numberWithBool:NO], API_JSON.Keys.MESSAGE : @"Http request failed !" };
    TXEvent *event            = [TXEvent createEvent:TXEvents.HTTPREQUESTFAILED eventSource:self eventProps:properties];
    [self fireEvent:event];
    
}

-(TXRequestObj *)createRequest:(NSString *)config {
    return [TXRequestObj initWithConfig:config andListener:self];
}

-(void)sendAsyncRequest:(TXRequestObj *) request {
    [self->httpMgr sendAsyncRequest:request];
}

@end
