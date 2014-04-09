//
//  TXSignUpVC.m
//  Taxi
//
//  Created by Irakli Vashakidze on 4/2/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXSignUpVC.h"
#import "TXUserModel.h"
#import "CMPopTipView.h"
#import "TXAskPhoneNumberVC.h"

@interface TXSignUpVC ()<UIActionSheetDelegate> {
    NSString *lastExistingUsername;
    BOOL userExists;
    CMPopTipView *popup;
}

-(IBAction)signUp:(id)sender;
-(IBAction)textFieldFocusLost:(UITextField *)sender;
-(IBAction)textFieldFocusGained:(UITextField *)sender;

@end

@implementation TXSignUpVC

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [TXUserModel instance];
    self->userExists = YES;
    [self refreshSignUpButton];
}

-(IBAction)signUp:(id)sender {
    
    if([self->lastExistingUsername isEqualToString:self.txtUsername.text]) {
        [self displayUserExistsPopup];
        [self refreshSignUpButton];
    } else {
        
        TXRootVC *viewController = [self viewControllerInstanceFromClass:[TXAskPhoneNumberVC class]];
        NSDictionary *params = @{
                                   API_JSON.Authenticate.USERNAME : self.txtUsername.text,
                                   API_JSON.Authenticate.PASSWORD : self.txtConfirmPassword.text
                                };
        
        [viewController setParameters:params];
        
        [self pushViewController:viewController];
        
    }
    
}

-(void) displayUserExistsPopup {
    self->popup = [[CMPopTipView alloc] initWithTitle:nil message:@"Username already exists!"];
    self->popup.backgroundColor = [UIColor redColor];
    self->popup.borderColor =[UIColor redColor];
    self->popup.has3DStyle = NO;
    self->popup.hasGradientBackground = NO;
    self->popup.hasShadow = NO;
    [self->popup presentPointingAtView:self.txtUsername inView:self.view animated:YES];
}

-(void)textFieldFocusLost:(UITextField *)sender {
    
    if(sender.tag == 1) {
    
        if(sender.text.length > 0) {
         
            [(TXUserModel *)self.model checkIfUserExists:sender.text providerId:nil providerUserId:nil];
            
        }
        
    }
    
    [self refreshSignUpButton];
}

-(void)textFieldFocusGained:(UITextField *)sender {
    
    if(sender.tag == 1 && self->userExists) {
        [self->popup removeFromSuperview];
    }
    
    [self refreshSignUpButton];
}

-(void) refreshSignUpButton {
    if(!self->userExists &&
        self.txtPassword.text.length > 0 &&
        self.txtConfirmPassword.text.length > 0 &&
        [self.txtPassword.text isEqualToString:self.txtConfirmPassword.text] &&
        ![self->lastExistingUsername isEqualToString:self.txtUsername.text]) {
       
        [self.btnSignUp setAlpha:1];
        [self.btnSignUp setEnabled:YES];
        
    } else {
        
        [self.btnSignUp setAlpha:0.5];
        [self.btnSignUp setEnabled:NO];
        
    }
}

-(void)onEvent:(TXEvent *)event eventParams:(id)subscriptionParams {
    
    if([event.name isEqualToString:TXEvents.CHECK_USER_COMPLETED]) {
        
        NSDictionary *data = [event getEventProperty:API_JSON.Keys.DATA];
        if([[data objectForKey:API_JSON.Authenticate.USEREXISTS] boolValue]) {
            
            self->userExists = YES;
            self->lastExistingUsername = self.txtUsername.text;
            [self displayUserExistsPopup];
            
        } else {
            
            self->userExists = NO;
        }
    }
    
}

@end
