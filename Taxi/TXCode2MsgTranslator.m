//
//  TXCodes.m
//  Taxi
//
//  Created by Irakli Vashakidze on 4/10/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

const int SUCCESS = 1000;
const int SYSTEM = 1001;
const int USERNAME_EXISTS = 1003;
const int REGISTER_REQUIRED_FIELDS = 1101;
const int REGISTER_REQUIRED_PARAMETERS = 1102;
const int GET_USER_NOT_EXISTS = 1103;
const int LOGIN_FAILED = 1104;
const int REGISTER_MOBILE_BLOCKED = 1105;
const int GET_USERNAME_EXISTS = 1106;
const int REGISTER_PASSWORD_LENGHT = 1107;
const int GET_PHONENUMBER_BLOCKED = 1108;

#import "TXCode2MsgTranslator.h"
#import "utils.h"

@interface TXCode2MsgTranslator() {
    NSDictionary *map;
}

@end

@implementation TXCode2MsgTranslator

/** Creates the single instance within the application
 
 @return TXCode2MsgTranslator
 */
+(TXCode2MsgTranslator *) instance {
    static dispatch_once_t pred;
    static TXCode2MsgTranslator* _instance;
    dispatch_once(&pred, ^{ _instance = [[self alloc] init]; });
    return _instance;
}

-(id)init {
    
    if(self = [super init]) {
        
        self->map = @{
                      
                         [NSNumber numberWithInt:SUCCESS] : LocalizedStr(@"Code.success"),
                         [NSNumber numberWithInt:SYSTEM] : @"Error occured, contact to administrator !",
                         [NSNumber numberWithInt:USERNAME_EXISTS] : @"User already registered !",
                         [NSNumber numberWithInt:REGISTER_REQUIRED_FIELDS] : @"Required fields inccorect !",
                         [NSNumber numberWithInt:REGISTER_REQUIRED_PARAMETERS] : @"Parameter are null !",
                         [NSNumber numberWithInt:GET_USER_NOT_EXISTS] : @"User does not exists !",
                         [NSNumber numberWithInt:LOGIN_FAILED] : @"Login failed !",
                         [NSNumber numberWithInt:REGISTER_MOBILE_BLOCKED] : @"Mobile Phone Blocked!",
                         [NSNumber numberWithInt:GET_USERNAME_EXISTS] : @"UserName Already Registered!",
                         [NSNumber numberWithInt:REGISTER_PASSWORD_LENGHT] : @"Password Lenght Less Then Required !",
                         [NSNumber numberWithInt:GET_PHONENUMBER_BLOCKED] : @"Phone Number Blocked"
                         
                      };

    }
    
    return self;
    
}

+(NSString *) messageForCode:(int) code {
    return [[TXCode2MsgTranslator instance]->map objectForKey:[NSNumber numberWithInt:code]];
}

@end