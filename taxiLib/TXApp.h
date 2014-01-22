//
//  TXApp.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/19/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXSettings.h"

@interface TXApp : NSObject

+(TXApp*) instance;
-(TXSettings *) getSettings;

@end
