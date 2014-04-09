//
//  TXRootVC.m
//  Taxi
//
//  Created by Irakli Vashakidze on 3/2/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXRootVC.h"
#import "TXUserModel.h"

@interface TXRootVC ()

@end

@implementation TXRootVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sharedObj = [TXSharedObj instance];
    self.model = [TXUserModel instance];
    [self.model addEventListener:self forEvent:TXEvents.REGISTER_USER_COMPLETED eventParams:nil];
    [self.model addEventListener:self forEvent:TXEvents.CHECK_USER_COMPLETED eventParams:nil];
	self.view.userInteractionEnabled = TRUE;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.signIn = [GPPSignIn sharedInstance];
    self.signIn.shouldFetchGooglePlusUser = YES;
    self.signIn.shouldFetchGoogleUserEmail = YES;
    self.signIn.clientID = KEYS.Google.CLIENTID;
    self.signIn.scopes = @[ kGTLAuthScopePlusLogin ];
    self.signIn.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * By default all the view controllers disable auto rotation,
 * if any UI view wants to display UI controls in landscape orientation, view controller must override this function
 */
-(BOOL)shouldAutorotate {
    return NO;
}

/*
 * By default all the view controllers handle touchesBegan to hide keyboard when it is not necessary,
 * If any UI view wants to force keyboard to be displayed permanently, it's controller should override this function
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (IBAction)backgroundTouched:(id)sender {
    [self.view endEditing:YES];
}

/*
 * Sets the model to the controller
 */
-(void)setModel:(TXModelBase *) model_ eventNames:(NSArray *) eventNames {
    self.model = model_;
    for (NSString *evtName in eventNames) {
        [self.model addEventListener:self forEvent:evtName eventParams:nil];
    }
}

-(void) pushViewController : (TXRootVC *) viewController {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self presentViewController:viewController animated:YES completion:nil];
    
}

-(TXRootVC *) viewControllerInstanceWithName: (NSString *) name {
    return [[self.sharedObj currentStoryBoard] instantiateViewControllerWithIdentifier:name];
}

-(TXRootVC *) viewControllerInstanceFromClass: (Class) aClass {
    return [[self.sharedObj currentStoryBoard] instantiateViewControllerWithIdentifier:NSStringFromClass(aClass)];
}

-(void) alertError : (NSString *) title message : (NSString *) message {
    
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
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
                
                [self.sharedObj.settings setGoogleUserId:person.identifier];
                self.googlePerson = person;
                
                TXUser *user = [[TXUser alloc] init];
                user.providerId = PROVIDERS.GOOGLE;
                user.providerUserId = person.identifier;
                
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
                
                [(TXUserModel *)self.model checkIfUserExists:user.username providerId:user.providerId providerUserId:user.providerUserId];
                
            }
        }];
        
        
    } else {
        
        NSString *msg = [NSString stringWithFormat:@"Error: %@\nReason: %@\n%@", [error localizedDescription], [error localizedFailureReason], [error localizedRecoverySuggestion]];
        
        [self alertError:[error localizedDescription] message:msg];
    }
    
    
}

-(void) setParameters:(NSDictionary *)params {
    self->parameters = params;
}

/*
 * Subclasses should override this function
 */
-(void)onEvent:(TXEvent *)event eventParams:(id)subscriptionParams{
    [self refreshInterfaceBasedOnSignIn];
}


-(void)refreshInterfaceBasedOnSignIn {
    NSLog(@"Function refreshInterfaceBasedOnSignIn not implemented in TXRootVC !");
}

@end
