//
//  TXViewController.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/19/14.
//  Copyright (c) 2014 99S. All rights reserved.
// 

#import <UIKit/UIKit.h>

@interface TXRegisterVC : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *objId;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *mobile;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *surname;
@property (strong, nonatomic) IBOutlet UITextField *note;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *language;
@property (strong, nonatomic) IBOutlet UITextField *photoURL;

-(IBAction)registerUser:(id)sender;
-(IBAction)login:(id)sender;
-(IBAction)update:(id)sender;

@end
