//
//  TXUserModel.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXUserModel.h"
#import "taxiLib/utils.h"
#import "Types.h"

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
    NSMutableDictionary *propertyMap = [[user getProperties] mutableCopy];
    [propertyMap removeObjectForKey:TXPropertyConsts.User.OBJID];
    [propertyMap removeObjectForKey:TXPropertyConsts.User.STATUSID];
    
    NSDictionary *jsonObj = @{
                                API_JSON.Keys.OPER  : [NSNumber numberWithInt:OPERATION_CREATE],
                                API_JSON.Keys.ATTR  : [NSNull null],
                                API_JSON.Keys.DATA  : propertyMap
                             };
    
    request.body = getJSONStr(jsonObj);
    [self sendAsyncRequest:request];
    
}

-(void)login:(NSString *)username andPass:(NSString *)pwd {
    
    TXRequestObj *request            = [self createRequest:HTTP_API.AUTHENTICATE];

    NSDictionary *propertyMap = @{ API_JSON.Authenticate.USERNAME : username, API_JSON.Authenticate.PASSWORD : pwd };
    
    NSDictionary *attributes = @{
                                 API_JSON.Authenticate.LOGINWITHPROVIDER : [NSNumber numberWithBool:NO]
                                 };
    
    NSDictionary *jsonObj = @{
                              API_JSON.Keys.OPER  : [NSNumber numberWithInt:OPERATION_OTHER],
                              API_JSON.Keys.ATTR  : attributes,
                              API_JSON.Keys.DATA  : propertyMap
                              };
    
    request.body = getJSONStr(jsonObj);
    [self sendAsyncRequest:request];
    
}

-(void)loginWithProvider:(TXUser *) user {
    
    TXRequestObj *request            = [self createRequest:HTTP_API.AUTHENTICATE];
    
    NSMutableDictionary *propertyMap = [[user getProperties] mutableCopy];
    [propertyMap removeObjectForKey:TXPropertyConsts.User.OBJID];
    [propertyMap removeObjectForKey:TXPropertyConsts.User.STATUSID];
    
    NSDictionary *attributes = @{
                                    API_JSON.Authenticate.LOGINWITHPROVIDER : [NSNumber numberWithBool:YES]
                                };
    
    NSDictionary *jsonObj = @{
                                API_JSON.Keys.OPER  : [NSNumber numberWithInt:OPERATION_OTHER],
                                API_JSON.Keys.ATTR  : attributes,
                                API_JSON.Keys.DATA  : propertyMap
                             };
    
    request.body = getJSONStr(jsonObj);
    [self sendAsyncRequest:request];
    
}

-(void)logout {
    
}

-(void)update:(TXUser *)user {
    
    TXRequestObj *request            = [self createRequest:HTTP_API.REGISTER];
    NSMutableDictionary *propertyMap = [[user getProperties] mutableCopy];
    [propertyMap removeObjectForKey:TXPropertyConsts.User.STATUSID];
    
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
    
    if(success == YES && [request.reqConfig.name isEqualToString:HTTP_API.REGISTER]) {
        
        NSDictionary *jsonObj           = getJSONObj(request.body);
        NSMutableDictionary *properties = [[jsonObj objectForKey:API_JSON.Keys.DATA] mutableCopy];
       // [self->application.settings setUserName:[properties objectForKey:TXPropertyConsts.User.USERNAME]];
       // [self->application.settings setPassword:[properties objectForKey:TXPropertyConsts.User.PASSWORD]];
        
        [properties removeObjectForKey:TXPropertyConsts.User.PASSWORD];
        TXUser *user = [TXUser create:properties];
        [self.application setUser:user];
        
    }
    
    NSString *data            = [responseObj objectForKey:API_JSON.Keys.DATA];
    NSLog(@"Recieved response from server: %@", data);
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
