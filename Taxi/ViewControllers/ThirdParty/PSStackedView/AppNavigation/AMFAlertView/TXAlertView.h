#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TXStackedViewController;

@interface TXAlertView : UIAlertView
@property (strong, nonatomic) NSDictionary *userInfo;
@property (readonly, nonatomic) BOOL canBeShown;
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id)delegate
stackedViewController:(TXStackedViewController *)stackedViewController
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...;
// Most common methods
+ (void)showInProgressAlert:(TXStackedViewController *)stackedViewController;
@end