//
//  TXUserModel.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXUserModel.h"
#import "taxiLib/utils.h"
#import "TXConsts.h"
#import "Types.h"

static NSString* const XCL_PROP_OBJID = @"objId";
static NSString* const XCL_PROP_STATUSID = @"statusId";

@implementation TXUserModel

/** Creates the single instance within the application
 
 @return TXUserModel
 */
+(TXUserModel *) instance {
    static dispatch_once_t pred;
    static TXUserModel* _instance;
    dispatch_once(&pred, ^{ _instance = [[self alloc] init]; });
    return _instance;
}

-(void)registerUser:(TXUser *)user {
    
    TXRequestObj *request            = [self createRequest:HTTP_API.REGISTER];
    NSMutableDictionary *propertyMap = [[user propertyMap] mutableCopy];
    [propertyMap removeObjectForKey:XCL_PROP_OBJID];
    [propertyMap removeObjectForKey:XCL_PROP_STATUSID];
    
    NSDictionary *jsonObj = @{
                                API_JSON.Keys.OPER  : [NSNumber numberWithInt:OPERATION_CREATE],
                                API_JSON.Keys.ATTR  : [NSNull null],
                                API_JSON.Keys.DATA  : propertyMap
                             };
    
    request.body     = getJSONStr(jsonObj);
    [self sendAsyncRequest:request];
    
}

-(void)login:(NSString *)username andPass:(NSString *)pwd {
    
}

-(void)logout {
    
}

-(void)update:(TXUser *)user {
    
    TXRequestObj *request            = [self createRequest:HTTP_API.REGISTER];
    NSMutableDictionary *propertyMap = [[user propertyMap] mutableCopy];
    [propertyMap removeObjectForKey:XCL_PROP_STATUSID];
    
    NSDictionary *jsonObj = @{
                              API_JSON.Keys.OPER  : [NSNumber numberWithInt:OPERATION_UPDATE],
                              API_JSON.Keys.ATTR  : [NSNull null],
                              API_JSON.Keys.DATA  : propertyMap
                              };
    
    request.body     = getJSONStr(jsonObj);

    [self->httpMgr sendAsyncRequest:request];
    
}

-(void)deleteUser {
    
}

-(void)onRequestCompleted:(id)object {
    
    TXRequestObj *request     = (TXRequestObj*)object;
    NSDictionary *responseObj = getJSONObj([[NSString alloc] initWithData:request.receivedData encoding:NSUTF8StringEncoding]);
    BOOL success              = [[responseObj objectForKey:API_JSON.Keys.SUCCESS] boolValue];
    NSString *data            = [responseObj objectForKey:API_JSON.Keys.DATA];
    NSDictionary *properties  = @{ API_JSON.Keys.SUCCESS : [NSNumber numberWithBool:success], API_JSON.Keys.DATA : data };
    TXEvent *event            = [TXEvent createEvent:TXEvents.REGISTER_USER_COMPLETED eventSource:self eventProps:properties];
    [self fireEvent:event];
}

-(void)onFail:(id)object error:(TXError *)error {

    NSDictionary *properties  = @{ API_JSON.Keys.SUCCESS : [NSNumber numberWithBool:NO] };
    TXEvent *event            = [TXEvent createEvent:TXEvents.REGISTER_USER_FAILED eventSource:self eventProps:properties];
    [self fireEvent:event];
}

@end
