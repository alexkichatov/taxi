#import <UIKit/UIKit.h>

@interface TXIndeterminateProgressViewController : UIViewController
- (void)startProgressWithMessage:(NSString *)message;
- (void)stopProgressWithMessage:(NSString *)message;
- (void)updateStatusMessage:(NSString *)message;
@end
