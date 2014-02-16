//
//  TXVM.h
//  Taxi
//
//  Created by Irakli Vashakidze on 2/16/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "taxiLib/TXUser.h"

@interface TXVM : NSObject

@property (nonatomic, strong) TXUser* user;

+(TXVM *) instance;

@end
