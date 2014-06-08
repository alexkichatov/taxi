//
//  TXAskPhoneNumberVC.h
//  Taxi
//
//  Created by Irakli Vashakidze on 4/9/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXUserVC.h"

@interface CountryCodeItem : NSObject
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* code;
@property (nonatomic, strong) UIImage*  image;
@end

@interface TXAskPhoneNumberVC : TXUserVC<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) IBOutlet UITextField *txtPhoneNumber;
@end
