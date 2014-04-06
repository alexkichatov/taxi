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

-(BOOL)checkIfUserExists:(NSString *) username providerId: (NSString *) providerId providerUserId:(NSString *) providerUserId  {
    
    TXRequestObj *request            = [self createRequest:HTTP_API.CHECKUSER];
    
    NSDictionary *propertyMap = @{
                                   API_JSON.Authenticate.USERNAME : username != nil ? username : [NSNull null],
                                   API_JSON.Authenticate.PROVIDERID : providerId != nil ? providerId : [NSNull null],
                                   API_JSON.Authenticate.PROVIDERUSERID : providerUserId != nil ? providerUserId : [NSNull null]
                                  };
    
    NSDictionary *jsonObj = @{
                              API_JSON.Keys.OPER  : [NSNumber numberWithInt:OPERATION_OTHER],
                              API_JSON.Keys.DATA  : propertyMap
                              };
    
    request.body = getJSONStr(jsonObj);
    id response = getJSONObj([self sendSyncRequest:request]);
    
    NSDictionary *data = getJSONObj([response objectForKey:API_JSON.Keys.DATA]);
    return [[data objectForKey:API_JSON.Authenticate.USEREXISTS] boolValue];
    
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
    
    NSDictionary *jsonObj = nil;
    NSDictionary *responseData = nil;
    NSString     *eventName = nil;
    
    if(success == YES) {
        
        jsonObj = getJSONObj(request.body);
        responseData = getJSONObj([responseObj objectForKey:API_JSON.Keys.DATA]);
        
    }
    
    if([request.reqConfig.name isEqualToString:HTTP_API.REGISTER]) {
       
        eventName = TXEvents.REGISTER_USER_COMPLETED;
       
    } else if ([request.reqConfig.name isEqualToString:HTTP_API.CHECKUSER]) {
        
        eventName = TXEvents.CHECK_USER_COMPLETED;
        
    }
    
    NSDictionary *properties  = @{
                                   API_JSON.Keys.SUCCESS : [NSNumber numberWithBool:success],
                                   API_JSON.Keys.DATA : responseData !=nil ? responseData : [NSNull null],
                                   API_JSON.Keys.MESSAGE : [responseObj objectForKey:API_JSON.Keys.MESSAGE]
                                 };
    
    TXEvent *event            = [TXEvent createEvent:eventName eventSource:self eventProps:properties];
    [self fireEvent:event];
}

-(void)onFail:(id)object error:(TXError *)error {

    NSDictionary *properties  = @{ API_JSON.Keys.SUCCESS : [NSNumber numberWithBool:NO] };
    TXEvent *event            = [TXEvent createEvent:TXEvents.REGISTER_USER_FAILED eventSource:self eventProps:properties];
    [self fireEvent:event];
}

@end
