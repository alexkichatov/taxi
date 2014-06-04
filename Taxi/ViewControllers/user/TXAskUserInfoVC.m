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
#import "TXSharedObj.h"

@interface TXAskUserInfoVC () {

}

-(IBAction)completeSignUp:(id)sender;

@end

@implementation TXAskUserInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)completeSignUp:(id)sender {
    
    TXUser *user_ = [TXUser create];
    
    user_.username = [self->parameters objectForKey:API_JSON.Authenticate.USERNAME];
    user_.password = [self->parameters objectForKey:API_JSON.Authenticate.PASSWORD];
    user_.mobile   = [self->parameters objectForKey:API_JSON.SignUp.PHONENUMBER];
    user_.providerId = [self->parameters objectForKey:API_JSON.Authenticate.PROVIDERID];
    user_.providerUserId = [self->parameters objectForKey:API_JSON.Authenticate.PROVIDERUSERID];
    user_.language = @"en";
    user_.name     = self.txtName.text;
    user_.surname  = self.txtSurname.text;
    user_.email    = self.txtEmail.text;
    
    [self.activityIndicator startAnimating];
    
    TXSyncResponseDescriptor *result = nil;
    result = [self->model signUp:user_];
    
    [self.activityIndicator stopAnimating];
    
    if(result.success) {
        
        if(user.providerId!=nil) {
            
            if([user.providerId isEqualToString:PROVIDERS.GOOGLE]) {
                [[TXSharedObj instance].settings setGoogleUserId:user.providerId];
            } else {
                [[TXSharedObj instance].settings setFBUserId:user.providerId];
            }
            
        }

        [self pushViewController:[self viewControllerInstanceFromClass:[TXMainVC class]]];
        
    } else {
        
        [self alertError:@"Error" message:[TXCode2MsgTranslator messageForCode:result.code]];
        
    }
    
    
}

@end
