//
//  TXCodes.m
//  Taxi
//
//  Created by Irakli Vashakidze on 4/10/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

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
                      
                         [NSNumber numberWithInt:success] : LocalizedStr(@"Code.success"),
                         [NSNumber numberWithInt:systemErr] : @"Error occured, contact to administrator !",
                         [NSNumber numberWithInt:usernameExists] : @"User already registered !",
                         [NSNumber numberWithInt:missingParameters] : @"Some Parameters are missing !",
                         [NSNumber numberWithInt:loginFailed] : @"Login failed !",
                         [NSNumber numberWithInt:mobileBlocked] : @"Mobile Phone Blocked!",
                         [NSNumber numberWithInt:passwordLength] : @"Password length is less than required !"
                         
                      };

    }
    
    return self;
    
}

+(NSString *) messageForCode:(int) code {
    return [[TXCode2MsgTranslator instance]->map objectForKey:[NSNumber numberWithInt:code]];
}

@end