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
    user_.providerID = [self->parameters objectForKey:API_JSON.Authenticate.PROVIDERID];
    user_.providerUserID = [self->parameters objectForKey:API_JSON.Authenticate.PROVIDERUSERID];
    user_.language = @"en";
    user_.name     = self.txtName.text;
    user_.surname  = self.txtSurname.text;
    user_.email    = self.txtEmail.text;
    
    [self.activityIndicator startAnimating];
    
    [[TXUserModel instance] signUp:user_];
    
    [self.activityIndicator stopAnimating];
    
//    if(result.success) {
//        
//        if(user_.providerID!=nil) {
//            
//            if([user_.providerID isEqualToString:PROVIDERS.GOOGLE]) {
//                [[TXSharedObj instance].settings setGoogleUserId:user_.providerID];
//            } else {
//                [[TXSharedObj instance].settings setFBUserId:user_.providerID];
//            }
//            
//        }
//
//        [self pushViewController:[self vcFromName:@"TXMainVC"]];
//        
//    } else {
//        
//        [self alertError:@"Error" message:[TXCode2MsgTranslator messageForCode:result.code]];
//        
//    }
    
    
}


-(void)onEvent:(TXEvent *)event eventParams:(id)subscriptionParams {
    
    TXResponseDescriptor *descriptor = [event getEventProperty:TXEvents.Params.DESCRIPTOR];
    if(descriptor.success) {
        
//        if(user_.providerID!=nil) {
//            
//            if([user_.providerID isEqualToString:PROVIDERS.GOOGLE]) {
//                [[TXSharedObj instance].settings setGoogleUserId:user_.providerID];
//            } else {
//                [[TXSharedObj instance].settings setFBUserId:user_.providerID];
//            }
//            
//        }
        
        [self pushViewController:[self vcFromName:@"TXMainVC"]];
        
    } else {
        
        [self alertError:@"Error" message:[TXCode2MsgTranslator messageForCode:descriptor.code]];
        
    }
}

@end
