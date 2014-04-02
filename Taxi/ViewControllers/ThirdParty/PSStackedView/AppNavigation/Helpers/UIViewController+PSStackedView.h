//
//  UIViewController+TXStackedView.h
//

#import <UIKit/UIKit.h>
#import "TXStackedViewGlobal.h"

@class TXContainerView, TXStackedViewController;

/// category for PSStackedView extensions
@interface UIViewController (TXStackedView)

- (CGFloat)stackWidth;

- (void)setStackWidth:(CGFloat)stackWidth;

/// returns the containerView, where view controllers are embedded
- (TXContainerView *)containerView;

/// returns the stack controller if the viewController is embedded
- (TXStackedViewController *)stackController;

// Called by stack or root VC right before controller is pushed
- (void)prepareForAppearance:(TXStackedViewController *)stackViewController;

// Called by controller to adjust its width
- (CGFloat)baseDesignatedWidthForOrientation:(UIInterfaceOrientation)orientation;

@end