//
//  TXSignCheckerVC.h
//  Taxi
//
//  Created by Irakli Vashakidze on 4/5/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXUserVC.h"
#import <GooglePlus/GooglePlus.h>

@interface TXSignCheckerVC : TXUserVC

@property (nonatomic, strong) GPPSignIn *signIn;

@end
