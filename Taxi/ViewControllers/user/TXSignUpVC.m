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
#import "TXSignInVC.h"

@interface TXSignUpVC ()<UIActionSheetDelegate> {
    NSString *lastExistingUsername;
    BOOL userExists;
    CMPopTipView *popup;
}

-(IBAction)signUp:(id)sender;
-(IBAction)signIn:(id)sender;
-(IBAction)textFieldFocusLost:(UITextField *)sender;
-(IBAction)textFieldFocusGained:(UITextField *)sender;

@end

@implementation TXSignUpVC

-(void)viewDidLoad {
    [super viewDidLoad];
    self->userExists = YES;
    
    [self configureStyles];
    
    
   // [self refreshSignUpButton];
}

-(void) configureStyles {
    
    [self.txtUsername setTextAlignment:NSTextAlignmentLeft];
    [self.txtUsername setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.txtUsername.layer.shadowOpacity = 0.0;
    [self.txtUsername.layer addSublayer:[TXUILayers layerWithRadiusTop:self.txtUsername.bounds color:[[UIColor whiteColor] CGColor]]];
    
    [self.txtPassword setTextAlignment:NSTextAlignmentLeft];
    [self.txtPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.txtPassword.layer.shadowOpacity = 0.0;
    [self.txtPassword.layer addSublayer:[TXUILayers layerWithRadiusNone:self.txtUsername.bounds color:[[UIColor whiteColor] CGColor]]];
    
    [self.txtConfirmPassword setTextAlignment:NSTextAlignmentLeft];
    [self.txtConfirmPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.txtConfirmPassword.layer.shadowOpacity = 0.0;
    [self.txtConfirmPassword.layer addSublayer:[TXUILayers layerWithRadiusNone:self.txtUsername.bounds color:[[UIColor whiteColor] CGColor]]];

    [self.btnSignUp.layer addSublayer:[TXUILayers layerWithRadiusBottom:self.btnSignUp.bounds color:[[UIColor orangeColor] CGColor]]];

    
}

-(IBAction)signUp:(id)sender {
    
    if([self->lastExistingUsername isEqualToString:self.txtUsername.text]) {
        [self displayUserExistsPopup];
        [self refreshSignUpButton];
    } else {
        
        TXAskPhoneNumberVC *viewController =  [[TXAskPhoneNumberVC alloc] initWithNibName:@"TXAskPhoneNumberVC" bundle:nil];

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
            
            TXUser *user = [[TXUser alloc] init];
            user.username = sender.text;
            [[TXUserModel instance] checkIfUserExistsAsync:user];
        }
        
    }
    
  //  [self refreshSignUpButton];
}

-(void)textFieldFocusGained:(UITextField *)sender {
    
    if(sender.tag == 1 && self->userExists) {
        [self->popup removeFromSuperview];
    }
    
   // [self refreshSignUpButton];
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

-(void)signIn:(id)sender {
    TXSignInVC *signInVC = [[TXSignInVC alloc] initWithNibName:@"TXSignInVC" bundle:nil];
    [self pushViewController:signInVC];
}

-(void)onEvent:(TXEvent *)event eventParams:(id)subscriptionParams {
    
    if([event.name isEqualToString:TXEvents.CHECK_USER_COMPLETED]) {
        
        BOOL success = [[event getEventProperty:API_JSON.Keys.SUCCESS] boolValue];
        int code     = [[event getEventProperty:API_JSON.Keys.CODE] intValue];
        
        if(!success && code == USERNAME_EXISTS) {
            
            self->userExists = YES;
            self->lastExistingUsername = self.txtUsername.text;
            [self displayUserExistsPopup];
            
        } else {
            
            self->userExists = NO;
            
        }
        
    } else if([event.name isEqualToString:TXEvents.CHECK_USER_FAILED]) {
        
        // TODO: handling
        
    } else if([event.name isEqualToString:TXEvents.NULLHTTPRESPONSE]) {
     
        // TODO: handling
        
    }
    
}

@end
