#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (Hierarchy)
- (UIView *)superviewOfClass:(Class)class;
@end