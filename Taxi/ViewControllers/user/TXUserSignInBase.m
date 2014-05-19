//
//  TXUserSignInBase.m
//  Taxi
//
//  Created by Irakli Vashakidze on 4/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXUserSignInBase.h"

@interface TXUserSignInBase ()

@end

@implementation TXUserSignInBase

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
                
                [self->model checkIfUserExists:self->user.username providerId:self->user.providerId providerUserId:self->user.providerUserId];
                
            }
        }];
        
        
    } else {
        
        NSString *msg = [NSString stringWithFormat:@"Error: %@\nReason: %@\n%@", [error localizedDescription], [error localizedFailureReason], [error localizedRecoverySuggestion]];
        
        [self alertError:[error localizedDescription] message:msg];
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
