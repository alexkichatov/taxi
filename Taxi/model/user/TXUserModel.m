//
//  TXUserModel.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXUserModel.h"
#import "utils.h"

const struct UserConsts UserConsts = {
    
    .USERNAME = @"username",
    .PASSWORD = @"password",
    .NAME = @"name",
    .SURNAME = @"surname",
    .EMAIL = @"email",
    .MOBILE = @"mobile",
    .STATUSID = @"statusID",
    .NOTE = @"note",
    .CREATEDATE = @"createDate",
    .MODIFICATIONDATE = @"modificationDate",
    .LANGUAGE = @"language",
    .PHOTOURL = @"photoURL",
    .PROVIDERUSERID = @"providerUserID",
    .PROVIDERID = @"providerID",
    .ISCONFIRMED = @"isConfirmed",
    .USERTOKEN = @"userToken"
    
};

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

-(void)signUp:(TXUser *)user {
    
    TXRequestObj *request            = [self createRequest:HttpAPIConsts.CREATEUSER];
    NSDictionary *propertyMap = @{
                                    UserConsts.USERNAME : user.username,
                                    UserConsts.PASSWORD : user.password,
                                    UserConsts.MOBILE : user.mobile,
                                    UserConsts.LANGUAGE : @"ka"
                                 };
    request.body = getJSONStr(propertyMap);
    [self sendAsyncRequest:request];
}

-(void) signIn:(NSString *)username password:(NSString *)password providerId:(NSNumber *) providerId providerUserId:(NSString*)providerUserId {
    
    TXRequestObj *request     = [self createRequest:HttpAPIConsts.LOGIN];
    NSDictionary *propertyMap = @{
                                    API_JSON.Authenticate.USERNAME : username!=nil ? username : [NSNull null],
                                    API_JSON.Authenticate.PASSWORD : password!=nil ? password : [NSNull null],
                                    API_JSON.Authenticate.PROVIDERID : providerId!=nil ? providerId : [NSNull null],
                                    API_JSON.Authenticate.PROVIDERUSERID : providerUserId!=nil ? providerUserId : [NSNull null],
                                 };
    request.body = getJSONStr(propertyMap);
    [self sendAsyncRequest:request];
    
}

-(void)authWithToken:(NSString *) userToken {
    TXRequestObj *request    = [self createRequest:HttpAPIConsts.AUTHWITHTOKEN];
    request.body = getJSONStr(@{ API_JSON.Authenticate.TOKEN : userToken });
    [self sendAsyncRequest:request];
}

-(void)checkIfPhoneNumberBlocked:(NSString *) phoneNum loginWithProvider: (BOOL) loginWithProvider {
    
    TXRequestObj *request    = [self createRequest:HttpAPIConsts.CHECKMOBILEPHONEBLOCKED];
    request.body = getJSONStr(@{ API_JSON.SignUp.PHONENUMBER : phoneNum });
    [self sendAsyncRequest:request];
    
}

-(void)checkIfUserExists:(TXUser *) user {
    
    TXRequestObj *request            = [self createRequest:HttpAPIConsts.CHECKUSEREXISTS];
    
    NSDictionary *propertyMap = @{
                                    API_JSON.Authenticate.USERNAME       : (user.username != nil ? user.username : [NSNull null]),
                                    API_JSON.Authenticate.PROVIDERID     : (user.providerID != nil ? user.providerID : [NSNull null]),
                                    API_JSON.Authenticate.PROVIDERUSERID : (user.providerUserID != nil ? user.providerUserID : [NSNull null])
                                  };
    
    request.body = getJSONStr(propertyMap);
    [self sendAsyncRequest:request];
    
}

-(void)confirm:(int) userId code:(int) code {
    
    TXRequestObj *request     = [self createRequest:HttpAPIConsts.CONFIRM];
    NSDictionary *propertyMap = @{
                                    API_JSON.Request.USERID : [NSNumber numberWithInt:userId],
                                    API_JSON.VERIFICATIONCODE : [NSNumber numberWithInt:code]
                                 };
    
    request.body = getJSONStr(propertyMap);
    [self sendAsyncRequest:request];
    
}

-(void)resendVerificationCode:(int) userId {
 
    TXRequestObj *request            = [self createRequest:HTTP_API.USER];
    request.body = getJSONStr(@{ API_JSON.Request.USERID : [NSNumber numberWithInt:userId] });
    [self sendAsyncRequest:request];
}

-(void)updateMobile:(int) userId mobile:(NSString *)mobile {
    
    TXRequestObj *request            = [self createRequest:HttpAPIConsts.UPDATEUSERMOBILE];
    
    NSDictionary *propertyMap = @{
                                    API_JSON.Request.USERID : [NSNumber numberWithInt:userId],
                                    API_JSON.SignUp.PHONENUMBER : mobile
                                  };
    
    request.body = getJSONStr(propertyMap);
    [self sendAsyncRequest:request];
}

-(void)logout {
    
}

-(void)update:(TXUser *)user {
    
    TXRequestObj *request            = [self createRequest:HttpAPIConsts.UPDATEUSER];
    NSMutableDictionary *propertyMap = [[user getProperties] mutableCopy];
    [propertyMap removeObjectForKey:TXPropertyConsts.User.STATUSID];
    request.body     = getJSONStr(propertyMap);
    [self->httpMgr sendAsyncRequest:request];
    
}

-(void)deleteUser {
    
}

-(void)onEvent:(TXEvent *)event eventParams:(id)subscriptionParams {
    
    if([event.name isEqualToString:TXEvents.HTTPREQUESTCOMPLETED]) {
        
        TXRequestObj *request = [event getEventProperty:TXEvents.Params.REQUEST];
        TXResponseDescriptor *descriptor = [event getEventProperty:TXEvents.Params.DESCRIPTOR];
        
        if([request.reqConfig.name isEqualToString:HttpAPIConsts.LOGIN]) {
            [self onLogin:descriptor];
        } else if([request.reqConfig.name isEqualToString:HttpAPIConsts.AUTHWITHTOKEN]) {
            [self onAuthWithToken:descriptor];
        } else if([request.reqConfig.name isEqualToString:HttpAPIConsts.CHECKUSEREXISTS]) {
            [self onCheckUserExists:descriptor];
        } else if([request.reqConfig.name isEqualToString:HttpAPIConsts.CHECKVERIFICATIONCODE]) {
            [self onCheckVerificationCode:descriptor];
        } else if([request.reqConfig.name isEqualToString:HttpAPIConsts.CONFIRM]) {
            [self onConfirm:descriptor];
        } else if([request.reqConfig.name isEqualToString:HttpAPIConsts.CREATEUSER]) {
            [self onCreateUser:descriptor];
        } else if([request.reqConfig.name isEqualToString:HttpAPIConsts.CHECKMOBILEPHONEBLOCKED]) {
            [self onCheckMobilePhoneBlocked:descriptor];
        } else if([request.reqConfig.name isEqualToString:HttpAPIConsts.GETUSER]) {
            [self onGetUser:descriptor];
        } else if([request.reqConfig.name isEqualToString:HttpAPIConsts.UPDATEUSER]) {
            [self onUpdateUser:descriptor];
        } else if([request.reqConfig.name isEqualToString:HttpAPIConsts.UPDATEUSERMOBILE]) {
            [self onUpdateUserMobile:descriptor];
        } else if([request.reqConfig.name isEqualToString:HttpAPIConsts.UPDATEUSERVERIFICATION]) {
            [self onUpdateUserVerification:descriptor];
        } else if([request.reqConfig.name isEqualToString:HttpAPIConsts.UPDATEUSERVERIFICATIONCODE]) {
            [self onUpdateUserVerificationCode:descriptor];
        }
        
    }
    
}

-(void)onLogin:(TXResponseDescriptor *)descriptor {
    [self fireEvent:[TXEvent createEvent:TXEvents.LOGIN
                             eventSource:self
                             eventProps:@{ TXEvents.Params.DESCRIPTOR : descriptor }]];
}

-(void)onAuthWithToken:(TXResponseDescriptor *)descriptor {
    [self fireEvent:[TXEvent createEvent:TXEvents.AUTHWITHTOKEN
                             eventSource:self
                             eventProps:@{ TXEvents.Params.DESCRIPTOR : descriptor }]];
}

-(void)onCheckUserExists:(TXResponseDescriptor *)descriptor {
    [self fireEvent:[TXEvent createEvent:TXEvents.CHECKUSEREXISTS
                             eventSource:self
                             eventProps:@{ TXEvents.Params.DESCRIPTOR : descriptor }]];
}

-(void)onCheckVerificationCode:(TXResponseDescriptor *)descriptor {
    [self fireEvent:[TXEvent createEvent:TXEvents.CHECKVERIFICATIONCODE
                             eventSource:self
                             eventProps:@{ TXEvents.Params.DESCRIPTOR : descriptor }]];
}

-(void)onConfirm:(TXResponseDescriptor *)descriptor {
    [self fireEvent:[TXEvent createEvent:TXEvents.CONFIRM
                             eventSource:self
                             eventProps:@{ TXEvents.Params.DESCRIPTOR : descriptor }]];
}

-(void)onCreateUser:(TXResponseDescriptor *)descriptor {
    [self fireEvent:[TXEvent createEvent:TXEvents.CREATEUSER
                             eventSource:self
                             eventProps:@{ TXEvents.Params.DESCRIPTOR : descriptor }]];
}

-(void)onCheckMobilePhoneBlocked:(TXResponseDescriptor *)descriptor {
    [self fireEvent:[TXEvent createEvent:TXEvents.CHECKMOBILEPHONEBLOCKED
                             eventSource:self
                             eventProps:@{ TXEvents.Params.DESCRIPTOR : descriptor }]];
}

-(void)onGetUser:(TXResponseDescriptor *)descriptor {
    [self fireEvent:[TXEvent createEvent:TXEvents.GETUSER
                             eventSource:self
                             eventProps:@{ TXEvents.Params.DESCRIPTOR : descriptor }]];
}

-(void)onUpdateUser:(TXResponseDescriptor *)descriptor {
    [self fireEvent:[TXEvent createEvent:TXEvents.UPDATEUSER
                             eventSource:self
                             eventProps:@{ TXEvents.Params.DESCRIPTOR : descriptor }]];
}

-(void)onUpdateUserMobile:(TXResponseDescriptor *)descriptor {
    [self fireEvent:[TXEvent createEvent:TXEvents.UPDATEUSERMOBILE
                             eventSource:self
                             eventProps:@{ TXEvents.Params.DESCRIPTOR : descriptor }]];
}

-(void)onUpdateUserVerification:(TXResponseDescriptor *)descriptor {
    [self fireEvent:[TXEvent createEvent:TXEvents.UPDATEUSERVERIFICATION
                             eventSource:self
                             eventProps:@{ TXEvents.Params.DESCRIPTOR : descriptor }]];
}

-(void)onUpdateUserVerificationCode:(TXResponseDescriptor *)descriptor {
    [self fireEvent:[TXEvent createEvent:TXEvents.UPDATEUSERVERIFICATIONCODE
                             eventSource:self
                             eventProps:@{ TXEvents.Params.DESCRIPTOR : descriptor }]];
}

@end
