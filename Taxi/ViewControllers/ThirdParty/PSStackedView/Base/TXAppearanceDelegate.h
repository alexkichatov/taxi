//
//  TXAppearanceDelegate.h
//  CRM
//
//  Created by Alexander Sharov on 03/12/13.
//  Copyright (c) 2013 LifeTech. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TXAppearanceDelegate <NSObject>
@optional
- (void)controllerDidLoad:(UIViewController *)viewController;
- (void)controllerWillAppear:(UIViewController *)viewController;
- (void)controllerDidAppear:(UIViewController *)viewController;
- (void)controllerWillDisappear:(UIViewController *)viewController;
- (void)controllerDidDisappear:(UIViewController *)viewController;
@end

