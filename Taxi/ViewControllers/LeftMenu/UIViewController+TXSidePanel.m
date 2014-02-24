//  Taxi
//
//  Created by Irakli Vashakidze on 1/19/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "UIViewController+TXSidePanel.h"

#import "TXSidePanelVC.h"

@implementation UIViewController (TXSidePanel)

- (TXSidePanelVC *)sidePanelController {
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[TXSidePanelVC class]]) {
            return (TXSidePanelVC *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;
}

@end
