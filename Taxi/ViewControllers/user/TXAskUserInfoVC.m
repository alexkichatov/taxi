    //
//  TXAskUserInfoVC.m
//  Taxi
//
//  Created by Irakli Vashakidze on 4/7/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXAskUserInfoVC.h"
#import "TXUserModel.h"
#import "TXMainVC.h"
#import "TXCode2MsgTranslator.h"

@interface TXAskUserInfoVC ()

-(IBAction)completeSignUp:(id)sender;

@end

@implementation TXAskUserInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.model = [TXUserModel instance];
}

-(void)completeSignUp:(id)sender {
    
    TXUser *user = [TXUser create];
    
    user.username = [self->parameters objectForKey:API_JSON.Authenticate.USERNAME];
    user.password = [self->parameters objectForKey:API_JSON.Authenticate.PASSWORD];
    user.mobile   = [self->parameters objectForKey:API_JSON.SignUp.PHONENUMBER];
    user.name     = self.txtName.text;
    user.surname  = self.txtSurname.text;
    user.email    = self.txtEmail.text;
    user.language = @"en";
    
    [self.activityIndicator startAnimating];
    
    TXSyncResponseDescriptor* result = [((TXUserModel*)self.model) signUp:user];

    [self.activityIndicator stopAnimating];
    
    if(result.success) {
        
       // [self pushViewController:[self viewControllerInstanceFromClass:[TXMainVC class]]];
        
    } else {
        
        [self alertError:@"Error" message:[TXCode2MsgTranslator messageForCode:result.code]];
        
    }
    
    
}

@end
