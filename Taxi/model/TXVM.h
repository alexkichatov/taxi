//
//  TXVM.h
//  Taxi
//
//  Created by Irakli Vashakidze on 2/16/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "taxiLib/TXUser.h"
#import "taxiLib/TXApp.h"

@interface TXVM : NSObject

@property (nonatomic, strong) TXUser* user;
@property (nonatomic, strong) TXSettings *settings;
@property (nonatomic, strong) TXApp *app;

+(TXVM *) instance;

@end
