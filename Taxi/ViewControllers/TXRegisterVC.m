//
//  TXViewController.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/19/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXRegisterVC.h"
#import "TXUserModel.h"

@interface TXRegisterVC ()

@end

@implementation TXRegisterVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.username.delegate = self;
    self.password.delegate = self;
    self.name.delegate = self;
    self.surname.delegate = self;
    self.mobile.delegate = self;
    self.note.delegate = self;
    self.email.delegate = self;
    self.language.delegate = self;
    self.photoURL.delegate = self;
    self.objId.delegate = self;
    
    self.loginView.frame = self.view.bounds; //whatever you want
    
    self.loginView.delegate = self;

}


- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
    NSLog(@"Logged In");
    
}

-(void)setProfilePicture {
    [FBSession.activeSession closeAndClearTokenInformation];
    
    NSArray *permissions = [NSArray arrayWithObjects:@"email", nil];
    
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         NSLog(@"\nfb sdk error = %@", error);
         switch (state) {
             case FBSessionStateOpen:
                 [[FBRequest requestForMe] startWithCompletionHandler:
                  ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                      if (!error) {
                          
                          self.userPictureView.profileID = [user objectForKey:@"id"];
                          
                      }
                  }];
                 break;
//             case FBSessionStateClosed:
//                 NSLog(@"%@", @"");
//                 break;
//             case FBSessionStateClosedLoginFailed:
//                 //need to handle
//                 break;
//             default:
//                 break;
         }
     }];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"usr_id::%@",user.id);
    NSLog(@"usr_first_name::%@",user.first_name);
    NSLog(@"usr_middle_name::%@",user.middle_name);
    NSLog(@"usr_last_nmae::%@",user.last_name);
    NSLog(@"usr_Username::%@",user.username);
    NSLog(@"usr_b_day::%@",user.birthday);
    NSLog(@"location::%@",user.location);
    [self setProfilePicture];
    
}
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // Called after logout
    NSLog(@"Logged out");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(IBAction)registerUser:(id)sender {
    
    TXUser *user = [TXUser create];
    
    user.username = self.username.text;
    user.password = self.password.text;
    user.mobile = self.mobile.text;
    user.name = self.name.text;
    user.surname = self.surname.text;
    user.note = self.note.text;
    user.photoURL = self.photoURL.text;
    user.email = self.email.text;
    user.language = self.language.text;
    
    [[TXUserModel instance] registerUser:user];
    
}

-(void)login:(id)sender {
    
    [[TXUserModel instance] login:self.username.text andPass:self.password.text];
    
}

-(void)update:(id)sender {
    
    TXUser *user = [TXUser create];
    
    user.objId    = [self.objId.text intValue];
    user.username = self.username.text;
    user.password = self.password.text;
    user.mobile = self.mobile.text;
    user.name = self.name.text;
    user.surname = self.surname.text;
    user.note = self.note.text;
    user.photoURL = self.photoURL.text;
    user.email = self.email.text;
    user.language = self.language.text;
    
    [[TXUserModel instance] update:user];
    
}

@end
