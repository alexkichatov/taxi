//
//  TXSignUpVC.h
//  Taxi
//
//  Created by Irakli Vashakidze on 4/2/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXUserVC.h"

@interface TXSignUpVC : TXUserVC

@property (nonatomic, strong) IBOutlet TXTextField *txtUsername;
@property (nonatomic, strong) IBOutlet TXTextField *txtPassword;
@property (nonatomic, strong) IBOutlet TXTextField *txtConfirmPassword;
@property (nonatomic, strong) IBOutlet TXTextField *txtEmail;
@property (nonatomic, strong) IBOutlet TXButton    *btnSignUp;
@property (nonatomic, strong) IBOutlet TXButton    *btnSignIn;

@end
