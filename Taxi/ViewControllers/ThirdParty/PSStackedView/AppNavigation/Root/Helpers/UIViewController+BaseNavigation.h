//
//  UIViewController+BaseNavigation.h
//  CRM
//
//  Created by Alexander Sharov on 22/11/13.
//  Copyright (c) 2013 LifeTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXBaseNavigationProtocol.h"

@interface UIViewController (BaseNavigation)
+ (id) createController;

- (BOOL)isTopController;

- (void) pushViewControllerAndPopPrevious:(ControllerCreationBlock)creationBlock completionBlock:(SimpleBlock)completionBlock;

- (void) pushOrPopViewControllerOfClass:(Class)controllerClass creationBlock:(ControllerCreationBlock)creationBlock completionBlock:(SimpleBlock)completionBlock;

- (void) pushOrPopViewControllerUsingCondition:(CustomPopConditionBlock)popConditionBlock creationBlock:(ControllerCreationBlock)creationBlock completionBlock:(SimpleBlock)completionBlock;

@end
