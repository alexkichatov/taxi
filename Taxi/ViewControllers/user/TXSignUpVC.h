//
//  TXSignUpVC.h
//  Taxi
//
//  Created by Irakli Vashakidze on 4/2/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXRootVC.h"

@interface TXSignUpVC : TXRootVC

@property (nonatomic, strong) IBOutlet UITextField *txtUsername;
@property (nonatomic, strong) IBOutlet UITextField *txtPassword;
@property (nonatomic, strong) IBOutlet UITextField *txtConfirmPassword;
@property (nonatomic, strong) IBOutlet UITextField *txtEmail;
@property (nonatomic, strong) IBOutlet UIButton    *btnSignUp;

@end
