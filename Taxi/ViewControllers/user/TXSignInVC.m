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

typedef enum {
    
    _SUCCESS = 1000,
    _INITIAL_REGISTRATION = 1020,
    _NO_MOBILE = 1021,
    _MOBILE_BLOCKED = 1006,
    _USER_NOT_CONFIRMED = 1019,
    _USER_BLOCKED = 1013,
    _AUTH_FAILED = 1008,
    _UNKNOWN_AUTH = 1018,
    
} SignInCodes;

@interface TXSignInVC ()<GPPSignInDelegate> {
    TXUser *user;
    TXSettings *settings;
}

-(IBAction)signIn:(id)sender;
-(IBAction)gpSignIn:(id)sender;
-(IBAction)signUpButtonTapped:(id)sender;

@end

@implementation TXSignInVC

#pragma mark - UIViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self configureFieldStyles];
    
    self->model = [TXUserModel instance];
    [self->model addEventListener:self forEvent:TXEvents.CHECK_USER_COMPLETED eventParams:nil];
    [self->model addEventListener:self forEvent:TXEvents.CHECK_PROVIDER_USER_COMPLETED eventParams:nil];
    [self->model addEventListener:self forEvent:TXEvents.CHECK_USER_FAILED eventParams:nil];
    [self->model addEventListener:self forEvent:TXEvents.REGISTER_USER_COMPLETED eventParams:nil];
    [self->model addEventListener:self forEvent:TXEvents.REGISTER_USER_FAILED eventParams:nil];
    
    self->settings = [[TXApp instance] getSettings];
    
    self.signIn = [GPPSignIn sharedInstance];
    self.signIn.shouldFetchGooglePlusUser = YES;
    self.signIn.shouldFetchGoogleUserEmail = YES;
    self.signIn.clientID = KEYS.Google.CLIENTID;
    self.signIn.scopes = @[ kGTLAuthScopePlusLogin ];
    self.signIn.delegate = self;
    
  
}

-(void) configureFieldStyles {
    
    [self.txtUsername setTextAlignment:NSTextAlignmentLeft];
    [self.txtUsername setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.txtUsername.layer.shadowOpacity = 0.0;
    [self.txtUsername.layer addSublayer:[TXUILayers layerWithRadiusTop:self.txtUsername.bounds color:[[UIColor whiteColor] CGColor]]];
    
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
                
                self.googlePerson = person;
                
                self->user = [[TXUser alloc] init];
                self->user.providerID = PROVIDERS.GOOGLE;
                self->user.providerUserID = person.identifier;
                
                NSDictionary *personProps = getJSONObj(person.JSONString);
                self->user.language = [personProps objectForKey:@"language"];
                
                NSArray *emails = [personProps objectForKey:@"emails"];
                if(emails.count>0) {
                    self->user.email = [emails[0] objectForKey:@"value"];
                }
                
                NSDictionary *name = [personProps objectForKey:@"name"];
                self->user.name = [name objectForKey:@"givenName"];
                self->user.surname = [name objectForKey:@"familyName"];
                
                NSDictionary *image = [personProps objectForKey:@"image"];
                self->user.photoURL = [image objectForKey:@"url"];
                
                TXSyncResponseDescriptor* response = [self->model signIn:self->user];
                [self proccessSignIn:response];
                
                
            }
        }];
        
        
    } else {
        
        NSString *msg = [NSString stringWithFormat:@"Error: %@\nReason: %@\n%@", [error localizedDescription], [error localizedFailureReason], [error localizedRecoverySuggestion]];
        
        [self alertError:[error localizedDescription] message:msg];
    }
    
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
            
            [self pushViewController:[self vcFromName:NSStringFromClass([TXMainVC class])]];
            
        } else {
            
            TXAskPhoneNumberVC *vc = (TXAskPhoneNumberVC *)[self vcFromName:NSStringFromClass([TXAskPhoneNumberVC class])];
            
            [vc setParameters:@{ API_JSON.Authenticate.PROVIDERID : user.providerID, API_JSON.Authenticate.PROVIDERUSERID : user.providerUserID }];
            [self pushViewController:vc];
            
        }
        
    }
    
}

-(IBAction)signIn:(id)sender {
    
    self->user = [[TXUser alloc] init];
    self->user.username = self.txtUsername.text;
    self->user.password = self.txtPassword.text;
    [self proccessSignIn:[self->model signIn:self->user]];
}

-(void)gpSignIn:(id)sender {
    [self showBusyIndicator];
}

-(void) proccessSignIn:(TXSyncResponseDescriptor *) descriptor {
    
    switch (descriptor.code) {
            
        case _SUCCESS:
            
            [self proccessSucceeded:descriptor];
            
            break;
            
        case _INITIAL_REGISTRATION:
            
            [self proccessSignedInFirstTime:descriptor];
            
            break;
        
         case _NO_MOBILE:
            
            [self proccessNoPhoneNumberSpecified:descriptor];
            
            break;
            
        case _MOBILE_BLOCKED:
            
            [self proccessMobileNumberIsBlocked:descriptor];
            
            break;
            
        case _USER_NOT_CONFIRMED:
            
            [self proccessNotActivated:descriptor];
            
            break;
     
        case _USER_BLOCKED:
            
            [self proccessIsBlocked:descriptor];
            
            break;
            
        case _AUTH_FAILED:
            
            [self proccessAuthorizationFailed:descriptor];
            
            break;
            
        case _UNKNOWN_AUTH:
            
            [self proccessUnknownAuth:descriptor];
            
            break;
    }
    
    [self hideBusyIndicator];
}

-(void) proccessSucceeded:(TXSyncResponseDescriptor *) descriptor {
    
    NSDictionary*source = (NSDictionary*)descriptor.source;
    [self->settings setUserToken:[source objectForKey:SettingsConst.CryptoKeys.USERTOKEN]];
    
    TXMapVC *mapVC = [[TXMapVC alloc] initWithNibName:@"TXMapVC" bundle:nil];
    [self pushViewController:mapVC];
    
}

-(void) proccessSignedInFirstTime:(TXSyncResponseDescriptor *) descriptor {
    
    TXAskPhoneNumberVC *vc = [self getAskPhoneNumberVC];
    
    NSDictionary*source = (NSDictionary*)descriptor.source;
    
    [vc setParameters:@{
                            API_JSON.OBJID : [NSNumber numberWithInt:[[source objectForKey:API_JSON.ID] intValue]]
                       }];
    
    [self pushViewController:vc];
    
}

-(void) proccessNoPhoneNumberSpecified:(TXSyncResponseDescriptor *) descriptor {
    [self proccessSignedInFirstTime:descriptor];
}

-(void) proccessNotActivated:(TXSyncResponseDescriptor *) descriptor {
    
    TXConfirmationVC *confVC = [[TXConfirmationVC alloc] initWithNibName:@"TXConfirmationVC" bundle:nil];
    
    NSDictionary*source = (NSDictionary*)descriptor.source;
    
    NSDictionary*params  = @{ API_JSON.ID : [source objectForKey:API_JSON.ID] };
    
    [confVC setParameters:params];
    [self pushViewController:confVC];
}

-(void) proccessIsBlocked:(TXSyncResponseDescriptor *) descriptor {
    [self alertError:@"Error" message:@"User is blocked !"];
}

-(void) proccessMobileNumberIsBlocked:(TXSyncResponseDescriptor *) descriptor {
    [self alertError:@"Error" message:@"Mobile number is blocked !"];
}

-(TXAskPhoneNumberVC *) getAskPhoneNumberVC {
    return [[TXAskPhoneNumberVC alloc] initWithNibName:@"TXAskPhoneNumberVC" bundle:nil];
}

-(void) proccessAuthorizationFailed:(TXSyncResponseDescriptor *) descriptor {
    [self alertError:@"Error" message:@"Incorrect username or password !"];
}

-(void) proccessUnknownAuth:(TXSyncResponseDescriptor *) descriptor {
    [self alertError:@"Error" message:@"Unknown authorization !"];
}

-(void)signUpButtonTapped:(id)sender {
    TXSignUpVC *signUpVC = [[TXSignUpVC alloc] initWithNibName:@"TXSignUpVC" bundle:nil];
    [self pushViewController:signUpVC];
}

@end
