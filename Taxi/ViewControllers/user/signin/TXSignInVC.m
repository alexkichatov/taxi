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
-(IBAction)signUp:(id)sender;
-(IBAction)didBeginEditing:(id)sender;

@end

@implementation TXSignInVC

#pragma mark - UIViewController

-(void)configureStyles {
    [super configureStyles];
    [self configureFieldStyles];
}

-(void) configure {
    [super configure];
    [self initControls];
    
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

-(void) initControls {
    self.txtUsername = [[TXTextField alloc]
                        initWithFrame:CGRectMake(kDefaultPaddingFromLeft,
                                                 self.view.frame.origin.y + kDefaultPaddingFromTopScreen,
                                                 self.view.frame.size.width - kDefaultPaddingFromLeft * 2,
                                                 kTextFieldDefaultHeight)];
    self.txtUsername.placeholder = @"Username";
    self.txtUsername.opaque = NO;
    self.txtUsername.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.txtUsername];
    
    self.txtPassword = [[TXTextField alloc] initUnder:self.txtUsername dim:0.3];
    self.txtPassword.placeholder = @"Password";
    self.txtPassword.secureTextEntry = true;
    [self.view addSubview:self.txtPassword];
    
    self.btnSignIn = [[TXButton alloc] initUnder:self.txtPassword dim:3];
    [self.btnSignIn setBackgroundColor:colorFromRGB(102, 178, 255, 1)];
    [self.btnSignIn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSignIn setTitle:@"Sign in" forState:UIControlStateNormal];
    [self.btnSignIn addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSignIn];
    
    self.btnForgotPassword = [[TXButton alloc] initUnder:self.btnSignIn dim:2];
    [self.btnForgotPassword setTintColor:[UIColor blueColor]];
    [self.btnForgotPassword setTitle:@"Forgot your password" forState:UIControlStateNormal];
//    [self.btnSignIn addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnForgotPassword];
    
    self.googleSignInButton = [[GPPSignInButton alloc]
                               initWithFrame:CGRectMake(self.btnForgotPassword.frame.origin.x,
                                                        (self.btnForgotPassword.frame.origin.y + self.btnForgotPassword.frame.size.height + 2),
                                                        self.btnForgotPassword.frame.size.width,
                                                        self.btnForgotPassword.frame.size.height)];
    [self.googleSignInButton addTarget:self action:@selector(gpSignIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.googleSignInButton];
    
    self.btnSignUp = [[TXButton alloc]
                      initWithFrame:CGRectMake(kDefaultPaddingFromLeft,
                                               (self.view.frame.size.height - kDefaultPaddingFromBottomScreen - kButtonDefaultHeight),
                                               (self.view.frame.size.width - kDefaultPaddingFromLeft * 2),
                                               kButtonDefaultHeight)];
    [self.btnSignUp setBackgroundColor:colorFromRGB(102, 0, 102, 1)];
    [self.btnSignUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSignUp setTitle:@"Sign up" forState:UIControlStateNormal];
    [self.btnSignUp addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSignUp];
   
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self configureFieldStyles];
}

-(void) configureFieldStyles {
    
    UIColor *bgColor = [UIColor whiteColor];
    
    [super configureStyles];
    [self.txtUsername setTextAlignment:NSTextAlignmentLeft];
    [self.txtUsername setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.txtUsername.layer.shadowOpacity = 0.0;
    [self.txtUsername.layer addSublayer:[TXUILayers layerWithRadiusTop:self.txtUsername.bounds color:[bgColor CGColor]]];
    [self.txtPassword setTextAlignment:NSTextAlignmentLeft];
    [self.txtPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.txtPassword.layer.shadowOpacity = 0.0;
    [self.txtPassword.layer addSublayer:[TXUILayers layerWithRadiusBottom:self.txtUsername.bounds color:[bgColor CGColor]]];
    
}

-(void)didBeginEditing:(id)sender {
    [self configureFieldStyles];
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

-(void)signUp:(id)sender {
    TXSignUpVC *signUpVC = [[TXSignUpVC alloc] initWithNibName:@"TXSignUpVC" bundle:nil];
    [self pushViewController:signUpVC];
}

-(void) proccessGenericError {
    [self alertError:@"Error" message:@"Unknown error occured !"];
}

@end
