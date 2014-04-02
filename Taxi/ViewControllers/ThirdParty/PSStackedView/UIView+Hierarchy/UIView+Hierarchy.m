#import "UIView+Hierarchy.h"


@implementation UIView (Hierarchy)


- (UIView *)superviewOfClass:(Class)class
{
    UIView *view = self.superview;
    while (view != nil)
    {
        if ([view isKindOfClass:class])
            return view;
        view = view.superview;
    }
    return nil;
}

@end