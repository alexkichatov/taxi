//
//  TXSignInVC.m
//  Taxi
//
//  Created by Irakli Vashakidze on 4/2/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXSignInVC.h"
#import "SlideNavigationController.h"

@interface TXSignInVC ()<GPPSignInDelegate>

@end

@implementation TXSignInVC

- (void)viewDidLoad
{
    self.view.userInteractionEnabled = TRUE;
    [super viewDidLoad];

}

-(void)refreshInterfaceBasedOnSignIn {
   
    if ([self.signIn authentication]) {
        // The user is signed in.
        self.googleSignInButton.hidden = YES;
        [self pushViewController:[[[TXSharedObj instance] currentStoryBoard] instantiateViewControllerWithIdentifier:NSStringFromClass([SlideNavigationController class])]];
        
    } else {
        self.googleSignInButton.hidden = NO;
        // Perform other actions here
    }
}

@end
