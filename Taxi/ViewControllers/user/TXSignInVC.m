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
#import "TXSharedObj.h"

@interface TXSignInVC ()<GPPSignInDelegate> {
    TXUser *user;
}

-(IBAction)signIn:(id)sender;

@end

@implementation TXSignInVC

- (void)viewDidLoad
{
    self.view.userInteractionEnabled = TRUE;
    [super viewDidLoad];

}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([PFUser currentUser]) {
//        self.welcomeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Welcome %@!", nil), [[PFUser currentUser] username]];
    } else {
//        self.welcomeLabel.text = NSLocalizedString(@"Not logged in", nil);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate


        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
    
}


#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}


#pragma mark - ()

- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refreshInterfaceBasedOnSignIn {
   
    [self->model addEventListener:self forEvent:TXEvents.CHECK_PROVIDER_USER_COMPLETED eventParams:nil];
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

-(IBAction)signIn:(id)sender {
    
    //[self->model login:self.txtUsername.text andPass:self.txtPassword];
    
}

@end
