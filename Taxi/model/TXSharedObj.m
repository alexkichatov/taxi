//
//  TXVM.m
//  Taxi
//
//  Created by Irakli Vashakidze on 2/16/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXSharedObj.h"

@interface TXSharedObj() {
    UIStoryboard *iPhoneStoryBoard;
    UIStoryboard *iPadStoryBoard;
    NSString     *deviceType;
}

@end

@implementation TXSharedObj

/** Creates the single instance within the application
 
 @return TXSharedVM
 */
+(TXSharedObj *) instance {
    static dispatch_once_t pred;
    static TXSharedObj* _instance;
    dispatch_once(&pred, ^{ _instance = [[self alloc] init]; });
    return _instance;
}

-(id)init {
    
    if(self = [super init]) {
        self.app      = [TXApp instance];
        self.settings = [self.app getSettings];
        self->iPhoneStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
        self->iPadStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle: nil];
        self->deviceType = [UIDevice currentDevice].model;
        self.signIn = [GPPSignIn sharedInstance];
        self.signIn.shouldFetchGooglePlusUser = YES;
        self.signIn.shouldFetchGoogleUserEmail = YES;
        self.signIn.clientID = KEYS.Google.CLIENTID;
        self.signIn.scopes = @[ kGTLAuthScopePlusLogin ];
    }
    
    return self;
}

-(UIStoryboard *)currentStoryBoard {
    
    if([self->deviceType isEqualToString:@"iPhone Simulator"]) {
        return self->iPhoneStoryBoard;
    } else if([self->deviceType isEqualToString:@"iPad"]) {
        return self->iPadStoryBoard;
    }
    
    return nil;
}

@end
