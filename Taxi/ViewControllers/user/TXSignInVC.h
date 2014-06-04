//
//  TXSignInVC.h
//  Taxi
//
//  Created by Irakli Vashakidze on 4/2/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXUserSignInBase.h"
#import <Parse/Parse.h>

@class GPPSignInButton;

@interface TXSignInVC : TXUserSignInBase<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (retain, nonatomic) IBOutlet GPPSignInButton *googleSignInButton;
@property (retain, nonatomic) IBOutlet UITextField *txtUsername;
@property (retain, nonatomic) IBOutlet UITextField *txtPassword;

@end
