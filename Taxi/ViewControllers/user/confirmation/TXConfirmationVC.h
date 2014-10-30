//
//  TXConfirmationVC.h
//  Taxi
//
//  Created by Irakli Vashakidze on 6/8/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXUserVC.h"

@interface TXConfirmationVC : TXUserVC

@property (nonatomic, strong) IBOutlet UITextField* txtCodeInput;
@property (nonatomic, strong) IBOutlet TXButton* btnSubmit;
@property (nonatomic, strong) IBOutlet TXButton* btnResend;

@end
