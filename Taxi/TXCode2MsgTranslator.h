//
//  TXCodes.h
//  Taxi
//
//  Created by Irakli Vashakidze on 4/10/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

extern const int SUCCESS;
extern const int SYSTEM;
extern const int USERNAME_EXISTS;
extern const int REGISTER_REQUIRED_FIELDS;
extern const int REGISTER_REQUIRED_PARAMETERS;
extern const int GET_USER_NOT_EXISTS;
extern const int LOGIN_FAILED;
extern const int REGISTER_MOBILE_BLOCKED;
extern const int GET_USERNAME_EXISTS;
extern const int REGISTER_PASSWORD_LENGHT;
extern const int GET_PHONENUMBER_BLOCKED;

typedef enum {
    
    success = 1000,
    systemErr  = 1001,
    usernameExists = 1003,
    loginFailed = 1104,
    initialRegistration = 1020,
    noMobile = 1021,
    mobileBlocked = 1006,
    userNotConfirmed = 1019,
    userBlocked = 1013,
    authFailed = 1008,
    
} ErrorCode;

@interface TXCode2MsgTranslator : NSObject

+(NSString *) messageForCode:(int) code;

@end