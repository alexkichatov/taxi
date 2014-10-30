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
    NSMutableArray *existingUsernames;
    CMPopTipView *popup;
    NSString *lastFreeUsername;
}

-(IBAction)signUp:(id)sender;
-(IBAction)signIn:(id)sender;
-(IBAction)textFieldFocusLost:(UITextField *)sender;
-(IBAction)textFieldFocusGained:(UITextField *)sender;
-(IBAction)textFieldValueChanged:(UITextField *)sender;

@end

@implementation TXSignUpVC

-(void) configure {
    [super configure];
    self->model = [TXUserModel instance];
    [self->model addEventListener:self forEvent:TXEvents.CHECKUSEREXISTS eventParams:nil];
    [self configureStyles];
    [self refreshSignUpButton];
}

-(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void) setAcceptedUsernameIcon {
    [self.txtUsername setRightViewMode:UITextFieldViewModeAlways];
    UIImage *image_ = [UIImage imageNamed:@"accepted.png"];
    UIImage *image = [self imageResize:image_ andResizeTo:CGSizeMake(15, 15)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.txtUsername.rightViewMode = UITextFieldViewModeAlways;
    self.txtUsername.rightView = imageView;

}

-(void) configureStyles {
    
    [super configureStyles];
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
    [self.txtConfirmPassword.layer addSublayer:[TXUILayers layerWithRadiusBottom:self.txtUsername.bounds color:[[UIColor whiteColor] CGColor]]];

}

-(IBAction)signUp:(id)sender {
    
    TXAskPhoneNumberVC *viewController =  [[TXAskPhoneNumberVC alloc] initWithNibName:@"TXAskPhoneNumberVC" bundle:nil];

    NSDictionary *params = @{
                               API_JSON.Authenticate.USERNAME : self.txtUsername.text,
                               API_JSON.Authenticate.PASSWORD : self.txtConfirmPassword.text
                            };
    
    [viewController setParameters:params];
    
    [self pushViewController:viewController];
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
    
    if([sender isEqual:self.txtUsername] && sender.text.length > 0) {

        if(![self->existingUsernames containsObject:self.txtUsername.text] && ![sender.text isEqualToString:self->lastFreeUsername]) {
            TXUser *user = [[TXUser alloc] init];
            user.username = sender.text;
            [self showBusyIndicator:@"Checking username ... "];
            [self->model checkIfUserExists:user];
        } else {
            [self displayUserExistsPopup];
        }
    }
    
    [self refreshSignUpButton];
}

-(void)textFieldFocusGained:(UITextField *)sender {
    if([sender isEqual:self.txtUsername]) {
        [self->popup removeFromSuperview];
        
        if(![sender.text isEqualToString:self->lastFreeUsername])
            [self.txtUsername setRightViewMode:UITextFieldViewModeNever];
    }
}

-(void)textFieldValueChanged:(UITextField *)sender {
    [self refreshSignUpButton];
}

-(void) refreshSignUpButton {
    
    if(self.txtPassword.text.length > 0 &&
       self.txtConfirmPassword.text.length > 0 &&
        [self.txtPassword.text isEqualToString:self.txtConfirmPassword.text] &&
        ![self->existingUsernames containsObject:[self.txtUsername.text uppercaseString]]) {
       
        [self.btnSignUp setAlpha:1];
        [self.btnSignUp setEnabled:YES];
        
    } else {
        
        [self.btnSignUp setAlpha:0.3];
        [self.btnSignUp setEnabled:NO];
        
    }
}

-(void)signIn:(id)sender {
    TXSignInVC *signInVC = [[TXSignInVC alloc] initWithNibName:@"TXSignInVC" bundle:nil];
    [self pushViewController:signInVC];
}

-(void)onEvent:(TXEvent *)event eventParams:(id)subscriptionParams {
    
    [self hideBusyIndicator];
    TXResponseDescriptor *descriptor = [event getEventProperty:TXEvents.Params.DESCRIPTOR];
    
    if([event.name isEqualToString:TXEvents.CHECKUSEREXISTS]) {
        
        if(descriptor.code == usernameExists) {
            if(self->existingUsernames == nil)
                self->existingUsernames = [NSMutableArray arrayWithCapacity:1];
            [self->existingUsernames addObject:[self.txtUsername.text uppercaseString]];
            [self displayUserExistsPopup];
            [self.txtUsername setRightViewMode:UITextFieldViewModeNever];
        } else {
            self->lastFreeUsername = self.txtUsername.text;
            [self setAcceptedUsernameIcon];
        }
        
    }
    
    [self refreshSignUpButton];
}

@end
