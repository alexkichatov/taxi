//
//  TXModelBase.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXModelBase.h"
#import "utils.h"

@implementation TXModelBase

-(id)init {
    
    if(self = [super init]) {
        self->httpMgr     = [TXHttpRequestManager instance];
        [self addEventListener:self forEvent:TXEvents.HTTPREQUESTCOMPLETED eventParams:nil];
        [self addEventListener:self forEvent:TXEvents.HTTPREQUESTFAILED eventParams:nil];
        [self addEventListener:self forEvent:TXEvents.NULLHTTPRESPONSE eventParams:nil];
    }
    
    return self;
}

-(void)onRequestCompleted:(id)object {
    
    TXEvent *event = nil;
    TXRequestObj *request = (TXRequestObj*)object;
    NSDictionary *responseObj = getJSONObj([[NSString alloc] initWithData:request.receivedData encoding:NSUTF8StringEncoding]);
    
    if(responseObj!=nil) {
        
        BOOL success = [[responseObj objectForKey:API_JSON.ResponseDescriptor.SUCCESS] boolValue];
        int  code = [[responseObj objectForKey:API_JSON.ResponseDescriptor.CODE] intValue];
        id   source = [responseObj objectForKey:API_JSON.ResponseDescriptor.SOURCE];
        id   message = [responseObj objectForKey:API_JSON.ResponseDescriptor.MESSAGE];
        
        TXResponseDescriptor *descriptor = [TXResponseDescriptor create:success code:code message:message source:source];
        
        event = [TXEvent createEvent:TXEvents.HTTPREQUESTCOMPLETED
                         eventSource:self
                          eventProps:@{
                                       TXEvents.Params.DESCRIPTOR : descriptor,
                                       TXEvents.Params.REQUEST    : request
                                       }];
        
    } else {
        
        event = [TXEvent createEvent:TXEvents.NULLHTTPRESPONSE eventSource:self eventProps:nil];
        
    }
    
    [self fireEvent:event];
}

-(void)onFail:(id)object error:(TXError *)error {
    
    TXResponseDescriptor *descriptor = [TXResponseDescriptor create:false code:0 message:@"Http request failed" source:nil];
    TXEvent *event            = [TXEvent createEvent:TXEvents.HTTPREQUESTFAILED
                                         eventSource:self
                                         eventProps:@{
                                                        TXEvents.Params.DESCRIPTOR : descriptor,
                                                        TXEvents.Params.REQUEST    : object
                                                      }];
    [self fireEvent:event];
    
}

-(TXRequestObj *)createRequest:(NSString *)config {
    return [TXRequestObj create:config urlParams:nil listener:self];
}

-(void)sendAsyncRequest:(TXRequestObj *) request {
    [self->httpMgr sendAsyncRequest:request];
}

-(id)sendSyncRequest:(TXRequestObj *) request {
    return [self->httpMgr sendSyncRequest:request];
}

-(void)onEvent:(TXEvent *)event eventParams:(id)subscriptionParams {
    NSAssert(false, @"Subclasses should override onEvent !");
}

@end
