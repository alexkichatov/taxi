

#import "UIView+FindFirstResponder.h"
#import "UIViewController+FindFirstResponder.h"


@implementation UIViewController (FindFirstResponder)

- (id)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    
    id firstResponder = [self.view findFirstResponder];
    if (firstResponder != nil) {
        return firstResponder;
    }
    
    for (UIViewController *childViewController in self.childViewControllers) {
        firstResponder = [childViewController findFirstResponder];
        
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}

@end
