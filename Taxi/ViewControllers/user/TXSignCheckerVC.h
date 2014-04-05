//
//  TXSignCheckerVC.h
//  Taxi
//
//  Created by Irakli Vashakidze on 4/5/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXRootVC.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface TXSignCheckerVC : TXRootVC

@property (nonatomic, strong) GPPSignIn *signIn;

@end
