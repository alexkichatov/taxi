//
//  UIViewController+BaseNavigation.m
//  CRM
//
//  Created by Alexander Sharov on 22/11/13.
//  Copyright (c) 2013 LifeTech. All rights reserved.
//

#import "UIViewController+BaseNavigation.h"
#import "TXStackedViewController.h"
#import "UIViewController+PSStackedView.h"

@implementation UIViewController (BaseNavigation)

+ (id)createController
{
    return [[self alloc] initWithNibName:NSStringFromClass(self) bundle:[NSBundle mainBundle]];
}


- (BOOL)isTopController
{
    UIViewController *topViewController = self.stackController.topViewController;
    return topViewController == self || topViewController == self.parentViewController;
}

- (void)pushViewControllerAndPopPrevious:(ControllerCreationBlock)creationBlock
{
    [self pushViewControllerAndPopPrevious:creationBlock completionBlock:nil];
}

- (void)pushViewControllerAndPopPrevious:(ControllerCreationBlock)creationBlock completionBlock:(SimpleBlock)completionBlock
{
    [self pushOrPopViewControllerUsingCondition:nil
                                  creationBlock:creationBlock
                                completionBlock:completionBlock];
}

- (void)pushOrPopViewControllerOfClass:(Class)controllerClass creationBlock:(ControllerCreationBlock)creationBlock completionBlock:(SimpleBlock)completionBlock
{
    [self pushOrPopViewControllerUsingCondition:^BOOL(UIViewController *topViewController){
        return ![topViewController isKindOfClass:controllerClass];
    }
                                  creationBlock:creationBlock
                                completionBlock:completionBlock];
}

- (void)pushOrPopViewControllerUsingCondition:(CustomPopConditionBlock)popConditionBlock
                                creationBlock:(ControllerCreationBlock)creationBlock
                              completionBlock:(SimpleBlock)completionBlock
{
    NSAssert(creationBlock, @"Creation block cannot be nil");
    TXStackedViewController *stackedViewController = self.stackController;
    BOOL popTopController = popConditionBlock?popConditionBlock(stackedViewController.topViewController):YES;
    if (popTopController)
    {
        
        UIViewController *currentController = self;
        UIViewController *baseViewController = creationBlock();

        [stackedViewController pushViewController:baseViewController fromViewController:currentController animated:YES];
        if (completionBlock)
            completionBlock();
    }
    else
    {

        [stackedViewController popToViewController:self animated:YES];
       
         if (completionBlock)
            completionBlock();
    }
}

@end
