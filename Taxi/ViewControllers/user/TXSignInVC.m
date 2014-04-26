//
//  TXSignInVC.m
//  Taxi
//
//  Created by Irakli Vashakidze on 4/2/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXSignInVC.h"
#import "SlideNavigationController.h"
#import "TXAskPhoneNumberVC.h"
#import "TXMainVC.h"
#import "TXUserModel.h"

@interface TXSignInVC ()<GPPSignInDelegate> {
    TXUser *user;
}

@end

@implementation TXSignInVC

- (void)viewDidLoad
{
    self.view.userInteractionEnabled = TRUE;
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
   
}

-(void)refreshInterfaceBasedOnSignIn {
   
    [self.model addEventListener:self forEvent:TXEvents.CHECK_PROVIDER_USER_COMPLETED eventParams:nil];
    if ([self.signIn authentication]) {
        // The user is signed in.
        self.googleSignInButton.hidden = YES;
        [self pushViewController:[[[TXSharedObj instance] currentStoryBoard] instantiateViewControllerWithIdentifier:NSStringFromClass([SlideNavigationController class])]];
        
    } else {
        self.googleSignInButton.hidden = NO;
        // Perform other actions here
    }
}

-(void)onEvent:(TXEvent *)event eventParams:(id)subscriptionParams {
    
    if(event!=nil && [event.name isEqualToString:TXEvents.CHECK_PROVIDER_USER_COMPLETED]) {
        
        BOOL success = [[event getEventProperty:API_JSON.Keys.SUCCESS] boolValue];
        int code     = [[event getEventProperty:API_JSON.Keys.CODE] intValue];
        
        if(!success && code == USERNAME_EXISTS) {
            
            [self pushViewController:[self viewControllerInstanceWithName:NSStringFromClass([TXMainVC class])]];
            
        } else {
            
            TXAskPhoneNumberVC *vc = (TXAskPhoneNumberVC *)[self viewControllerInstanceWithName:NSStringFromClass([TXAskPhoneNumberVC class])];
            
            [vc setParameters:@{ API_JSON.Authenticate.PROVIDERID : user.providerId, API_JSON.Authenticate.PROVIDERUSERID : user.providerUserId }];
            [self pushViewController:vc];
            
        }
        
    }
    
}

@end
