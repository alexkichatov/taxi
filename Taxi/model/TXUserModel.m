//
//  TXUserModel.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXUserModel.h"
#import "utils.h"

typedef enum {
    
    _SIGNUP = 1,
    _CHECKPHONENUMBERISBLOCKED = 8,
    _SIGNIN = 9,
    _UPDATE = 3,
    _DELETE = 4,
    _LIST = 5,
    _CHECK = 6,
    _CONFIRM = 13,
    _OTHER = 7,
    _GENERATECODE = 12,
    _UPDATEMOBILE = 14,
} OperationCodes;

@implementation TXUser

@end

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

-(TXSyncResponseDescriptor *)signUp:(TXUser *)user {
    
    TXRequestObj *request            = [self createRequest:HTTP_API.USER];
    NSDictionary *propertyMap = [user getProperties];
    
    NSDictionary *jsonObj = @{
                                API_JSON.Keys.OPER  : [NSNumber numberWithInt:_SIGNUP],
                                API_JSON.Keys.ATTR  : @{ API_JSON.Authenticate.LOGINWITHPROVIDER : user.providerId == nil ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES] },
                                API_JSON.Keys.DATA  : propertyMap
                             };
    
    request.body = getJSONStr(jsonObj);
    return [self sendSyncRequest:request];
}

-(TXSyncResponseDescriptor *)signIn:(TXUser *)user {
    
    TXRequestObj *request     = [self createRequest:HTTP_API.USER];

    NSDictionary *jsonObj     = @{
                                    API_JSON.Keys.OPER : [NSNumber numberWithInt:_SIGNIN],
                                    API_JSON.Keys.DATA : [user getProperties],
                                    API_JSON.Keys.ATTR : @{}
                                 };
    
    request.body = getJSONStr(jsonObj);
    return [self sendSyncRequest:request];
    
}

-(TXSyncResponseDescriptor *)checkIfPhoneNumberBlocked:(NSString *) phoneNum loginWithProvider: (BOOL) loginWithProvider {
    
    TXRequestObj *request    = [self createRequest:HTTP_API.USER];
    NSDictionary *attributes = @{
                                    API_JSON.Authenticate.LOGINWITHPROVIDER :
                                    [NSNumber numberWithBool:loginWithProvider]
                                };
    
    NSDictionary *jsonObj = @{
                                API_JSON.Keys.OPER  : [NSNumber numberWithInt:_CHECKPHONENUMBERISBLOCKED],
                                API_JSON.Keys.ATTR  : attributes,
                                API_JSON.Keys.DATA  : @{ API_JSON.SignUp.PHONENUMBER : phoneNum }
                             };
    
    request.body = getJSONStr(jsonObj);
    return [self sendSyncRequest:request];
    
}

-(void)checkIfUserExistsAsync:(TXUser *) user {
    
    TXRequestObj *request            = [self createRequest:HTTP_API.USER];
    
    NSDictionary *propertyMap = @{
                                   API_JSON.Authenticate.USERNAME :
                                       (user.username != nil ? user.username : [NSNull null]),
                                   API_JSON.Authenticate.PROVIDERID :
                                       (user.providerId != nil ? user.providerId : [NSNull null]),
                                   API_JSON.Authenticate.PROVIDERUSERID :
                                       (user.providerUserId != nil ? user.providerUserId : [NSNull null])
                                  };
    
    NSDictionary *jsonObj = @{
                              API_JSON.Keys.OPER  : [NSNumber numberWithInt:_CHECK],
                              API_JSON.Keys.DATA  : propertyMap,
                             };
    
    request.body = getJSONStr(jsonObj);
    [self sendAsyncRequest:request];
    
}

-(TXSyncResponseDescriptor *)checkIfUserExistsSync:(TXUser *) user {
    
    TXRequestObj *request            = [self createRequest:HTTP_API.USER];
    
    NSDictionary *propertyMap = @{
                                  API_JSON.Authenticate.USERNAME :
                                      (user.username != nil ? user.username : [NSNull null]),
                                  API_JSON.Authenticate.PROVIDERID :
                                      (user.providerId != nil ? user.providerId : [NSNull null]),
                                  API_JSON.Authenticate.PROVIDERUSERID :
                                      (user.providerUserId != nil ? user.providerUserId : [NSNull null])
                                  };
    
    NSDictionary *jsonObj = @{
                              API_JSON.Keys.OPER  : [NSNumber numberWithInt:_CHECK],
                              API_JSON.Keys.DATA  : propertyMap,
                              };
    
    request.body = getJSONStr(jsonObj);
    return [self sendSyncRequest:request];
    
}

-(TXSyncResponseDescriptor *)confirm:(int) userId code:(NSString *) code {
    
    if(code.length == 0) {
        return nil;
    }
    
    TXRequestObj *request            = [self createRequest:HTTP_API.USER];
    
    NSDictionary *propertyMap = @{
                                    API_JSON.OBJID : [NSNumber numberWithInt:userId],
                                    API_JSON.VERIFICATIONCODE : code
                                 };
    
    NSDictionary *jsonObj = @{
                              API_JSON.Keys.OPER  : [NSNumber numberWithInt:_CONFIRM],
                              API_JSON.Keys.DATA  : propertyMap,
                              API_JSON.Keys.ATTR  : @{}
                              };
    
    request.body = getJSONStr(jsonObj);
    return [self sendSyncRequest:request];
    
}

-(TXSyncResponseDescriptor *)resendVerificationCode:(int) userId {
 
    TXRequestObj *request            = [self createRequest:HTTP_API.USER];
    
    NSDictionary *propertyMap = @{
                                    API_JSON.OBJID : [NSNumber numberWithInt:userId]
                                };
    
    NSDictionary *jsonObj = @{
                              API_JSON.Keys.OPER  : [NSNumber numberWithInt:_GENERATECODE],
                              API_JSON.Keys.DATA  : propertyMap,
                              API_JSON.Keys.ATTR  : @{}
                              };
    
    request.body = getJSONStr(jsonObj);
    return [self sendSyncRequest:request];
}

-(TXSyncResponseDescriptor *)updateMobile:(int) userId mobile:(NSString *)mobile {
    
    TXRequestObj *request            = [self createRequest:HTTP_API.USER];
    
    NSDictionary *propertyMap = @{
                                    API_JSON.OBJID : [NSNumber numberWithInt:userId],
                                    API_JSON.SignUp.PHONENUMBER : mobile
                                  };
    
    NSDictionary *jsonObj = @{
                              API_JSON.Keys.OPER  : [NSNumber numberWithInt:_UPDATEMOBILE],
                              API_JSON.Keys.DATA  : propertyMap,
                              API_JSON.Keys.ATTR  : @{}
                              };
    
    request.body = getJSONStr(jsonObj);
    return [self sendSyncRequest:request];
}

-(void)logout {
    
}

-(void)update:(TXUser *)user {
    
    TXRequestObj *request            = [self createRequest:HTTP_API.USER];
    NSMutableDictionary *propertyMap = [[user getProperties] mutableCopy];
    [propertyMap removeObjectForKey:TXPropertyConsts.User.STATUSID];
    
    NSDictionary *jsonObj = @{
                                API_JSON.Keys.OPER  : [NSNumber numberWithInt:_UPDATE],
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
    NSString     *responseStr = [[NSString alloc] initWithData:request.receivedData encoding:NSUTF8StringEncoding];
    NSDictionary *responseObj = getJSONObj(responseStr);
    TXEvent      *event = nil;
    NSDictionary *source = nil;
    NSDictionary *properties = nil;
    NSDictionary *reqBody = nil;
    
    NSLog(@"Response: %@", responseStr);
    
    if(responseObj!=nil) {
        
        BOOL success   = [[responseObj objectForKey:API_JSON.Keys.SUCCESS] boolValue];
        int  operation = [[responseObj objectForKey:API_JSON.Keys.OPER] intValue];
        int  code      = [[responseObj objectForKey:API_JSON.Keys.CODE] intValue];
        
        source = [responseObj objectForKey:API_JSON.Keys.SOURCE];
        
        switch (operation) {
                
                case _CHECK:
                
                properties  = @{
                                 API_JSON.Keys.SUCCESS : [NSNumber numberWithBool:success],
                                 API_JSON.Keys.CODE    : [NSNumber numberWithInt:code],
                                 API_JSON.Keys.MESSAGE : [responseObj objectForKey:API_JSON.Keys.MESSAGE]
                               };
                
                reqBody = [getJSONObj(request.body) objectForKey:API_JSON.Keys.ATTR];
                
                if([[reqBody objectForKey:API_JSON.Authenticate.LOGINWITHPROVIDER] boolValue] == NO) {
                
                    event = [TXEvent createEvent:TXEvents.CHECK_USER_COMPLETED eventSource:self eventProps:properties];
                    
                } else {
                    
                    event = [TXEvent createEvent:TXEvents.CHECK_PROVIDER_USER_COMPLETED eventSource:self eventProps:properties];
                    
                }
                
                break;
                
                    
            default:
                
                properties  = @{
                                API_JSON.Keys.MESSAGE : @"Unrecognized operation code received !"
                                };
                
                event = [TXEvent createEvent:TXEvents.CHECK_USER_FAILED eventSource:self eventProps:properties];
                break;
        }
        
    } else {
        
        event = [TXEvent createEvent:TXEvents.NULLHTTPRESPONSE eventSource:self eventProps:properties];
        
    }
    
    [self fireEvent:event];
}

-(void)onFail:(id)object error:(TXError *)error {

    NSDictionary *properties  = @{ API_JSON.Keys.SUCCESS : [NSNumber numberWithBool:NO] };
    TXEvent *event            = [TXEvent createEvent:TXEvents.REGISTER_USER_FAILED eventSource:self eventProps:properties];
    [self fireEvent:event];
}

@end
