//
//  TXSignCheckerVC.m
//  Taxi
//
//  Created by Irakli Vashakidze on 4/5/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXSignCheckerVC.h"
#import "SlideNavigationController.h"
#import "TXSignInVC.h"
#import "StrConsts.h"
#import "TXSharedObj.h"
#import "TXMainVC.h"
#import "TXAskPhoneNumberVC.h"
#import "TXUserModel.h"

@implementation TXSignCheckerVC

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if([[TXSharedObj instance].settings getGoogleUserId] == nil) {
        
        [self.activityIndicator removeFromSuperview];
        [self pushViewController:[self vcFromName:NSStringFromClass([TXSignInVC class])]];
        
    } else {
        
        [self.signIn authenticate];
        
    }

}

-(void)refreshInterfaceBasedOnSignIn {
    
    if ([self.signIn authentication]!=nil) {
        // The user is signed in.
        [self pushViewController:[self vcFromName:NSStringFromClass([SlideNavigationController class])]];
        
    } else {
        
        [self pushViewController:[self vcFromName:NSStringFromClass([TXSignInVC class])]];
        
    }
}

-(void)onEvent:(TXEvent *)event eventParams:(id)subscriptionParams {
    
    if(event!=nil && [event.name isEqualToString:TXEvents.CHECK_PROVIDER_USER_COMPLETED]) {
        
//        BOOL success = [[event getEventProperty:API_JSON.Keys.SUCCESS] boolValue];
//        int code     = [[event getEventProperty:API_JSON.Keys.CODE] intValue];
//        
//        if(!success && code == USERNAME_EXISTS) {
//            
//            [self pushViewController:[self vcFromName:NSStringFromClass([TXMainVC class])]];
//            
//        } else {
//            
//            TXAskPhoneNumberVC *vc = (TXAskPhoneNumberVC *)[self vcFromName:NSStringFromClass([TXAskPhoneNumberVC class])];
//            
////            [vc setParameters:@{ API_JSON.Authenticate.PROVIDERID : user.providerId, API_JSON.Authenticate.PROVIDERUSERID : user.providerUserId }];
//            [self pushViewController:vc];
//            
//        }
        
    }
    
}

@end
