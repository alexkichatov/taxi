//
//  TXAskUserInfoVC.h
//  Taxi
//
//  Created by Irakli Vashakidze on 4/7/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXRootVC.h"

@interface TXAskUserInfoVC : TXRootVC

@property (nonatomic, strong) IBOutlet UITextField *txtName;
@property (nonatomic, strong) IBOutlet UITextField *txtSurname;
@property (nonatomic, strong) IBOutlet UITextField *txtEmail;

@end
