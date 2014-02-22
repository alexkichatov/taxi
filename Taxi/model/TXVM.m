//
//  TXVM.m
//  Taxi
//
//  Created by Irakli Vashakidze on 2/16/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXVM.h"

@implementation TXVM

/** Creates the single instance within the application
 
 @return TXVM
 */
+(TXVM *) instance {
    static dispatch_once_t pred;
    static TXVM* _instance;
    dispatch_once(&pred, ^{ _instance = [[self alloc] init]; });
    return _instance;
}

-(id)init {
    
    if(self = [super init]) {
        self.app      = [TXApp instance];
        self.settings = [self.app getSettings];
    }
    
    return self;
}

@end
