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
#import "TXConfirmationVC.h"
#import "TXSignUpVC.h"
#import "TXMapVC.h"

@interface TXSignInVC ()<GPPSignInDelegate>

-(IBAction)signIn:(id)sender;
-(IBAction)gpSignIn:(id)sender;
-(IBAction)signUpButtonTapped:(id)sender;

@end

@implementation TXSignInVC

#pragma mark - UIViewController

-(void)configureStyles {
    [super configureStyles];
    [self configureFieldStyles];
}

-(void) configure {
    [super configure];
    [[[self->model getApp] getSettings] setUserId:nil];
    [self->model addEventListener:self forEvent:TXEvents.CHECKUSEREXISTS eventParams:nil];
    [self->model addEventListener:self forEvent:TXEvents.LOGIN eventParams:nil];

    self.signIn = [GPPSignIn sharedInstance];
    self.signIn.shouldFetchGooglePlusUser = YES;
    self.signIn.shouldFetchGoogleUserEmail = YES;
    self.signIn.clientID = KEYS.Google.CLIENTID;
    self.signIn.scopes = @[ kGTLAuthScopePlusLogin ];
    self.signIn.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self configureFieldStyles];
}

-(void) configureFieldStyles {
    
    self.txtUsername.height = 40;
    [self.txtUsername setTextAlignment:NSTextAlignmentLeft];
    [self.txtUsername setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.txtUsername.layer.shadowOpacity = 0.0;
    [self.txtUsername.layer addSublayer:[TXUILayers layerWithRadiusTop:self.txtUsername.bounds color:[[UIColor whiteColor] CGColor]]];
    
    [self.txtPassword setFrame:CGRectMake(self.txtUsername.frame.origin.x, self.txtUsername.frame.origin.y + 40.5, self.txtUsername.frame.size.width, self.txtUsername.frame.size.height)];
    
    self.txtPassword.height = 40;
    [self.txtPassword setTextAlignment:NSTextAlignmentLeft];
    [self.txtPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.txtPassword.layer.shadowOpacity = 0.0;
    [self.txtPassword.layer addSublayer:[TXUILayers layerWithRadiusBottom:self.txtUsername.bounds color:[[UIColor whiteColor] CGColor]]];
    
    
}


- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth error: (NSError *) error {
    
    if(error==nil) {
        
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
        plusService.retryEnabled = YES;
        [plusService setAuthorizer:self.signIn.authentication];
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        [plusService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLPlusPerson *person, NSError *error) {
            
            if (error) {
                
                NSString *msg = [NSString stringWithFormat:@"Error: %@\nReason: %@\n%@", [error localizedDescription], [error localizedFailureReason], [error localizedRecoverySuggestion]];
                
                [self alertError:[error localizedDescription] message:msg];
                
            } else {
                [self proceedWithGoogleSignIn:person];
            }
        }];
        
        
    } else {
        
        NSString *msg = [NSString stringWithFormat:@"Error: %@\nReason: %@\n%@", [error localizedDescription], [error localizedFailureReason], [error localizedRecoverySuggestion]];
        
        [self alertError:[error localizedDescription] message:msg];
    }
    
}

-(void) proceedWithGoogleSignIn:(GTLPlusPerson *)person {
    
    self.googlePerson = person;
    
    TXUser *user = [[TXUser alloc] init];
    user.providerID = PROVIDERS.GOOGLE;
    user.providerUserID = person.identifier;
    
    NSDictionary *personProps = getJSONObj(person.JSONString);
    user.language = [personProps objectForKey:@"language"];
    
    NSArray *emails = [personProps objectForKey:@"emails"];
    if(emails.count>0) {
        user.email = [emails[0] objectForKey:@"value"];
    }
    
    NSDictionary *name = [personProps objectForKey:@"name"];
    user.name = [name objectForKey:@"givenName"];
    user.surname = [name objectForKey:@"familyName"];
    
    NSDictionary *image = [personProps objectForKey:@"image"];
    user.photoURL = [image objectForKey:@"url"];
    
    [self->model signIn:user];
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
    
    [self hideBusyIndicator];
    TXResponseDescriptor *descriptor = [event getEventProperty:TXEvents.Params.DESCRIPTOR];
    [self proccessSignIn:descriptor];
    
}

-(IBAction)signIn:(id)sender {
    
    TXUser *user = [[TXUser alloc] init];
    user.username = self.txtUsername.text;
    user.password = self.txtPassword.text;
    
    [self showBusyIndicator:@"Authenticating ... "];
    [self->model signIn:self.txtUsername.text password:self.txtPassword.text providerId:nil providerUserId:nil];
}

-(void)gpSignIn:(id)sender {
    [self showBusyIndicator];
}

-(void) proccessSignIn:(TXResponseDescriptor *) descriptor {
    
    switch (descriptor.code) {
            
        case success:
            
            [self proccessSucceeded:descriptor];
            
            break;
            
        case initialRegistration:
            
            [self proccessSignedInFirstTime:descriptor];
            
            break;
        
         case noMobile:
            
            [self proccessNoPhoneNumberSpecified:descriptor];
            
            break;
            
        case mobileBlocked:
            
            [self proccessMobileNumberIsBlocked:descriptor];
            
            break;
            
        case userNotConfirmed:
            
            [self proccessNotActivated:descriptor];
            
            break;
     
        case userBlocked:
            
            [self proccessIsBlocked:descriptor];
            
            break;
            
        case authFailed:
            
            [self proccessAuthorizationFailed:descriptor];
            
            break;
            
        case systemErr:
            
            [self proccessGenericError];
            
            break;
    }
    
    [self hideBusyIndicator];
}

-(void) proccessSucceeded:(TXResponseDescriptor *) descriptor {
    
    NSDictionary*source = (NSDictionary*)descriptor.source;
    [[[TXApp instance] getSettings] setUserToken:[source objectForKey:SettingsConst.CryptoKeys.USERTOKEN]];
    [[[TXApp instance] getSettings] setUserId:[source objectForKey:API_JSON.ID]];
    
    TXMapVC *mapVC = [[TXMapVC alloc] initWithNibName:@"TXMapVC" bundle:nil];
    [self pushViewController:mapVC];
    
}

-(void) proccessSignedInFirstTime:(TXResponseDescriptor *) descriptor {
    
    TXAskPhoneNumberVC *vc = [self getAskPhoneNumberVC];
    
    NSDictionary*source = (NSDictionary*)descriptor.source;
    
    [vc setParameters:@{
                            API_JSON.Request.USERID : [NSNumber numberWithInt:[[source objectForKey:API_JSON.ID] intValue]]
                       }];
    
    [self pushViewController:vc];
    
}

-(void) proccessNoPhoneNumberSpecified:(TXResponseDescriptor *) descriptor {
    [self proccessSignedInFirstTime:descriptor];
}

-(void) proccessNotActivated:(TXResponseDescriptor *) descriptor {
    
    TXConfirmationVC *confVC = [[TXConfirmationVC alloc] initWithNibName:@"TXConfirmationVC" bundle:nil];
    NSDictionary*source = (NSDictionary*)descriptor.source;
    [[[self->model getApp] getSettings] setUserId:[source objectForKey:API_JSON.ID]];
    [self pushViewController:confVC];
}

-(void) proccessIsBlocked:(TXResponseDescriptor *) descriptor {
    [self alertError:@"Error" message:@"User is blocked !"];
}

-(void) proccessMobileNumberIsBlocked:(TXResponseDescriptor *) descriptor {
    [self alertError:@"Error" message:@"Mobile number is blocked !"];
}

-(TXAskPhoneNumberVC *) getAskPhoneNumberVC {
    return [[TXAskPhoneNumberVC alloc] initWithNibName:@"TXAskPhoneNumberVC" bundle:nil];
}

-(void) proccessAuthorizationFailed:(TXResponseDescriptor *) descriptor {
    [self alertError:@"Error" message:@"Incorrect username or password !"];
}

-(void) proccessUnknownAuth:(TXResponseDescriptor *) descriptor {
    [self alertError:@"Error" message:@"Unknown authorization !"];
}

-(void)signUpButtonTapped:(id)sender {
    TXSignUpVC *signUpVC = [[TXSignUpVC alloc] initWithNibName:@"TXSignUpVC" bundle:nil];
    [self pushViewController:signUpVC];
}

-(void) proccessGenericError {
    [self alertError:@"Error" message:@"Unknown error occured !"];
}

@end
