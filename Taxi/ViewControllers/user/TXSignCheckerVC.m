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
#import "TXConsts.h"
#import "TXSharedObj.h"

@interface TXSignCheckerVC ()<GPPSignInDelegate> {

}

@end

@implementation TXSignCheckerVC

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if([self.sharedObj.settings getGoogleUserId] == nil) {
        
        [self.activityIndicator removeFromSuperview];
        [self pushViewController:[self viewControllerInstanceWithName:NSStringFromClass([TXSignInVC class])]];
        
    } else {
        
        [self.signIn authenticate];
        
    }

}

-(void)refreshInterfaceBasedOnSignIn {
    
    if ([self.signIn authentication]!=nil) {
        // The user is signed in.
        [self pushViewController:[self viewControllerInstanceWithName:NSStringFromClass([SlideNavigationController class])]];
        
    } else {
        
        [self pushViewController:[self viewControllerInstanceWithName:NSStringFromClass([TXSignInVC class])]];
        
    }
}

-(void)onEvent:(TXEvent *)event eventParams:(id)subscriptionParams {
    
}

@end
