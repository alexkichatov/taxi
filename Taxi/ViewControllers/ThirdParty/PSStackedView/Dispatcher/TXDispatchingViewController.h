#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TXRootViewController;

@interface TXDispatchingViewController : UIViewController
@property (nonatomic, strong) TXRootViewController * rootMenuController;
- (id)init;
@end