//
//  TXAppDelegate.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/19/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXEventTarget.h"

@interface TXAppDelegate : UIResponder <UIApplicationDelegate, TXEventListener>

@property (strong, nonatomic) UIWindow *window;

@end
