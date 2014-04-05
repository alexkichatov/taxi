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
    
    if([[TXSharedObj instance].settings getGoogleUserId] == nil) {
        [self.activityIndicator removeFromSuperview];
        [self pushViewController:[[self.sharedObj currentStoryBoard] instantiateViewControllerWithIdentifier:NSStringFromClass([TXSignInVC class])]];
    } else {
        
        self.sharedObj.signIn.delegate = self;
        [self.signIn authenticate];
        
    }

}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth error: (NSError *) error {
    
    if(error==nil) {
        
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
        plusService.retryEnabled = YES;
        [plusService setAuthorizer:self.sharedObj.signIn.authentication];
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        [plusService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLPlusPerson *person, NSError *error) {
            
            if (error) {
                
                GTMLoggerError(@"Error: %@", error);
                
                
            } else {
                
                [self.sharedObj.settings setGoogleUserId:person.identifier];
                
            }
        }];
        
        
    } else {
        
        NSString *msg = [NSString stringWithFormat:@"Error: %@\nReason: %@\n%@", [error localizedDescription], [error localizedFailureReason], [error localizedRecoverySuggestion]];
        
        [self alertError:[error localizedDescription] message:msg];
    }
    
    [self refreshInterfaceBasedOnSignIn];
    
}

-(void)refreshInterfaceBasedOnSignIn {
    
    if ([self.signIn authentication]) {
        // The user is signed in.
        [self pushViewController:[[self.sharedObj currentStoryBoard] instantiateViewControllerWithIdentifier:NSStringFromClass([SlideNavigationController class])]];
        
    } else {
        
        [self pushViewController:[[self.sharedObj currentStoryBoard] instantiateViewControllerWithIdentifier:NSStringFromClass([TXSignInVC class])]];
        
    }
}


@end
