//
//  TXCallModel.m
//  Taxi
//
//  Created by Irakli Vashakidze on 5/10/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXCallModel.h"
#import "TXError.h"

const int CALL_OPER_CHARGEREQUEST = 1;

@implementation TXCallModel

/** Creates the single instance within the application
 
 @return TXCallModel
 */
+(TXCallModel *) instance {
    static dispatch_once_t pred;
    static TXCallModel* _instance;
    dispatch_once(&pred, ^{ _instance = [[self alloc] init]; });
    return _instance;
}

-(void) requestChargeForCountry:(NSString *) country distance:(long) distance {

    TXRequestObj *request     = [self createRequest:HTTP_API.CALL];
    NSDictionary *propertyMap = @{
                                  API_JSON.Call.COUNTRY : country,
                                  API_JSON.Call.DISTANCE : [NSNumber numberWithLong:distance]
                                 };
    
    NSDictionary *jsonObj = @{
                                API_JSON.Request.DATA  : propertyMap
                              };
    
    request.body = getJSONStr(jsonObj);
    [self sendAsyncRequest:request];
    
}

-(void)onRequestCompleted:(id)object {
    
//    TXRequestObj *request     = (TXRequestObj*)object;
//    NSString     *responseStr = [[NSString alloc] initWithData:request.receivedData encoding:NSUTF8StringEncoding];
//    NSDictionary *responseObj = getJSONObj(responseStr);
//    TXEvent      *event = nil;
//    NSDictionary *source = nil;
//    NSDictionary *properties = nil;
//    
//    NSLog(@"Response: %@", responseStr);
//    
//    if(responseObj!=nil) {
//        
//        BOOL success   = [[responseObj objectForKey:API_JSON.Keys.SUCCESS] boolValue];
//        int  operation = [[responseObj objectForKey:API_JSON.Keys.OPER] intValue];
//        int  code      = [[responseObj objectForKey:API_JSON.Keys.CODE] intValue];
//        
//        source = [responseObj objectForKey:API_JSON.Keys.SOURCE];
//        
//        switch (operation) {
//                
//            case CALL_OPER_CHARGEREQUEST:
//                
//                properties  = @{
//                                API_JSON.Keys.SUCCESS : [NSNumber numberWithBool:success],
//                                API_JSON.Keys.CODE    : [NSNumber numberWithInt:code],
//                                API_JSON.Keys.SOURCE  : source
//                               };
//                
//                event = [TXEvent createEvent:TXEvents.CALL_CHARGE_REQUEST_COMPLETED eventSource:self eventProps:properties];
//                    
//                break;
//                
//            default:
//                
//                properties  = @{
//                                API_JSON.Keys.MESSAGE : @"Unrecognized operation code received !"
//                                };
//                
//                event = [TXEvent createEvent:TXEvents.CALL_CHARGE_REQUEST_FAILED eventSource:self eventProps:properties];
//                break;
//        }
//        
//    } else {
//        
//        event = [TXEvent createEvent:TXEvents.NULLHTTPRESPONSE eventSource:self eventProps:properties];
//        
//    }
//    
//    [self fireEvent:event];
}

-(void)onFail:(id)object error:(TXError *)error {
    
//    NSDictionary *properties  = @{
//                                    API_JSON.Keys.SUCCESS : [NSNumber numberWithBool:NO],
//                                    TXEvents.Params.ERROR : (error!=nil ? error : [NSNull null])
//                                 };
//    TXEvent *event            = [TXEvent createEvent:TXEvents.CALL_CHARGE_REQUEST_FAILED eventSource:self eventProps:properties];
//    [self fireEvent:event];
}


@end
