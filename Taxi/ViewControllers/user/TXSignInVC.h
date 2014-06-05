//
//  TXSignInVC.h
//  Taxi
//
//  Created by Irakli Vashakidze on 4/2/14.
//  Copyright (c) 2014 99S. All rights reserved.
//
#import "TXUserModel.h"
#import <GooglePlus/GooglePlus.h>
#import "TXRootVC.h"

@class GPPSignInButton;

@interface TXSignInVC : TXRootVC<GPPSignInDelegate> 

@property (nonatomic, strong) GPPSignIn     *signIn;
@property (nonatomic, strong) GTLPlusPerson *googlePerson;
@property (retain, nonatomic) IBOutlet GPPSignInButton *googleSignInButton;
@property (retain, nonatomic) IBOutlet UITextField *txtUsername;
@property (retain, nonatomic) IBOutlet UITextField *txtPassword;

@end
