//
//  UIViewController+PSStackedView.m

static NSString *const kPSSVAssociatedStackViewControllerWidth = @"kPSSVAssociatedStackViewControllerWidth";

#import "UIViewController+PSStackedView.h"
#import "TXContainerView.h"
#import "TXStackedViewController.h"
#import <objc/runtime.h>

@implementation UIViewController (TXStackedView)

// returns the containerView, where view controllers are embedded
- (TXContainerView *)containerView
{
    return ([self.view.superview isKindOfClass:[TXContainerView class]] ? (TXContainerView *)self.view.superview : nil);
}

// returns the stack controller if the viewController is embedded
- (TXStackedViewController *)stackController
{
    TXStackedViewController *stackController = nil;
    UIViewController *viewController = self;
    while (viewController != nil){
        stackController = objc_getAssociatedObject(viewController, (__bridge void *const) kPSSVAssociatedStackViewControllerKey);
        if (stackController)
            return stackController;
        
        viewController = viewController.parentViewController;
    }
    
    return stackController;
}

- (void)prepareForAppearance:(TXStackedViewController *)stackViewController
{

}

- (CGFloat)stackWidth
{
    NSNumber *stackWidthNumber = objc_getAssociatedObject(self, (__bridge void *const) kPSSVAssociatedStackViewControllerWidth);
    CGFloat stackWidth = stackWidthNumber ? [stackWidthNumber floatValue] : 0.f;
    return stackWidth;
}

- (void)setStackWidth:(CGFloat)stackWidth
{
    NSNumber *stackWidthNumber = [NSNumber numberWithFloat:stackWidth];
    objc_setAssociatedObject(self, (__bridge void *const)  kPSSVAssociatedStackViewControllerWidth, stackWidthNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)baseDesignatedWidthForOrientation:(UIInterfaceOrientation)orientation
{
    CGRect appFrame = [UIScreen mainScreen].bounds;
    CGFloat availableWidth = (UIInterfaceOrientationIsLandscape(orientation)?CGRectGetHeight(appFrame):CGRectGetWidth(appFrame)) - self.stackController.leftInset;
    return availableWidth;
}

@end