//
//  TXStackedViewDelegate.h
//  TXStackedView
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TXStackedViewController;

@protocol TXStackedViewDelegate <NSObject>
@optional
- (void)stackedViewController:(TXStackedViewController *)stackedViewController willShowViewController:(UIViewController *)viewController;
- (void)stackedViewController:(TXStackedViewController *)stackedViewController didShowViewController:(UIViewController *)viewController;
- (void)stackedView:(TXStackedViewController *)stackedView didPanViewController:(UIViewController *)viewController byOffset:(NSInteger)offset;
- (void)stackedViewDidAlign:(TXStackedViewController *)stackedView;
- (CGFloat) maximalItemWidthForStackedView:(TXStackedViewController *)stackedViewController;
- (CGFloat) maximalItemHeightForStackedView:(TXStackedViewController *)stackedViewController;

- (CGFloat) topItemOffsetForStackedView:(TXStackedViewController *)stackedViewController;
@end
