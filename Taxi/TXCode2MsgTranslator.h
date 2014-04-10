//
//  TXCodes.h
//  Taxi
//
//  Created by Irakli Vashakidze on 4/10/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

extern const int SUCCESS;
extern const int SYSTEM;
extern const int REGISTER_USERNAME_EXISTS;
extern const int REGISTER_REQUIRED_FIELDS;
extern const int REGISTER_REQUIRED_PARAMETERS;
extern const int GET_USER_NOT_EXISTS;
extern const int LOGIN_FAILED;
extern const int REGISTER_MOBILE_BLOCKED;
extern const int GET_USERNAME_EXISTS;
extern const int REGISTER_PASSWORD_LENGHT;
extern const int GET_PHONENUMBER_BLOCKED;

@interface TXCode2MsgTranslator : NSObject

+(NSString *) messageForCode:(int) code;

@end