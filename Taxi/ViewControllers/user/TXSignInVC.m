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

typedef enum {
    
    _SUCCESS = 1000,
    _INITIAL_REGISTRATION = 1020,
    _NO_MOBILE = 1021,
    _MOBILE_BLOCKED = 1006,
    _USER_NOT_CONFIRMED = 1019,
    _USER_BLOCKED = 1013,
    
} SignInCodes;

@interface TXSignInVC ()<GPPSignInDelegate> {
    TXUser *user;
    TXUserModel *model;
}

-(IBAction)signIn:(id)sender;

@end

@implementation TXSignInVC

#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self->model = [TXUserModel instance];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self->model = [TXUserModel instance];
    [self->model addEventListener:self forEvent:TXEvents.CHECK_USER_COMPLETED eventParams:nil];
    [self->model addEventListener:self forEvent:TXEvents.CHECK_PROVIDER_USER_COMPLETED eventParams:nil];
    [self->model addEventListener:self forEvent:TXEvents.CHECK_USER_FAILED eventParams:nil];
    [self->model addEventListener:self forEvent:TXEvents.REGISTER_USER_COMPLETED eventParams:nil];
    [self->model addEventListener:self forEvent:TXEvents.REGISTER_USER_FAILED eventParams:nil];
    
    self.signIn = [GPPSignIn sharedInstance];
    self.signIn.shouldFetchGooglePlusUser = YES;
    self.signIn.shouldFetchGoogleUserEmail = YES;
    self.signIn.clientID = KEYS.Google.CLIENTID;
    self.signIn.scopes = @[ kGTLAuthScopePlusLogin ];
    self.signIn.delegate = self;
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
                self->user.providerId = PROVIDERS.GOOGLE;
                self->user.providerUserId = person.identifier;
                
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
            
            [self pushViewController:[self viewControllerInstanceWithName:NSStringFromClass([TXMainVC class])]];
            
        } else {
            
            TXAskPhoneNumberVC *vc = (TXAskPhoneNumberVC *)[self viewControllerInstanceWithName:NSStringFromClass([TXAskPhoneNumberVC class])];
            
            [vc setParameters:@{ API_JSON.Authenticate.PROVIDERID : user.providerId, API_JSON.Authenticate.PROVIDERUSERID : user.providerUserId }];
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

-(void) proccessSignIn:(TXSyncResponseDescriptor *) descriptor {
    
    NSDictionary * data = (NSDictionary*)descriptor.source;
    int code = [[data objectForKey:API_JSON.Keys.CODE] intValue];
    
    switch (code) {
            
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
    }
    
    
}

-(void) proccessSucceeded:(TXSyncResponseDescriptor *) descriptor {
    
    
    
}

-(void) proccessSignedInFirstTime:(TXSyncResponseDescriptor *) descriptor {
    
    TXAskPhoneNumberVC *vc = [self getAskPhoneNumberVC];
    
    NSDictionary*source = getJSONObj([((NSDictionary*)descriptor.source) objectForKey:API_JSON.Keys.SOURCE]);
    
    NSString *providerId = [source objectForKey:API_JSON.Authenticate.PROVIDERID];
    NSString *providerUserId = [source objectForKey:API_JSON.Authenticate.PROVIDERUSERID];
    
    [vc setParameters:@{
                         API_JSON.Authenticate.PROVIDERID : providerId,
                         API_JSON.Authenticate.PROVIDERUSERID : providerUserId
                       }];
    
    [self pushViewController:vc];
    
}

-(void) proccessNoPhoneNumberSpecified:(TXSyncResponseDescriptor *) descriptor {
    [self proccessSignedInFirstTime:descriptor];
}

-(void) proccessNotActivated:(TXSyncResponseDescriptor *) descriptor {
    //TODO: Display confirmation code input
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

@end
