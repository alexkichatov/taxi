//
//  TXVM.h
//  Taxi
//
//  Created by Irakli Vashakidze on 2/16/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXUser.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "TXApp.h"
#import "TXConsts.h"

@interface TXSharedObj : NSObject

@property (nonatomic, strong) TXUser* user;
@property (nonatomic, strong) TXSettings *settings;
@property (nonatomic, strong) TXApp *app;

+(TXSharedObj *) instance;
-(UIStoryboard*) currentStoryBoard;

@end
