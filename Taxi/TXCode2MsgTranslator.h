//
//  TXCodes.h
//  Taxi
//
//  Created by Irakli Vashakidze on 4/10/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

typedef enum {
    
    success = 1000,
    systemErr  = 1001,
    missingParameters  = 1002,
    usernameExists = 1003,
    loginFailed = 1104,
    initialRegistration = 1020,
    noMobile = 1021,
    mobileBlocked = 1006,
    passwordLength = 1007,
    userNotConfirmed = 1019,
    userBlocked = 1013,
    authFailed = 1008
    
} ErrorCode;

@interface TXCode2MsgTranslator : NSObject

+(NSString *) messageForCode:(int) code;

@end