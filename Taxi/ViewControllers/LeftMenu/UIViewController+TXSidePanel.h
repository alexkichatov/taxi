//  Taxi
//
//  Created by Irakli Vashakidze on 1/19/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TXSidePanelVC;

/* This optional category provides a convenience method for finding the current
 side panel controller that your view controller belongs to. It is similar to the
 Apple provided "navigationController" and "tabBarController" methods.
 */
@interface UIViewController (TXSidePanel)

// The nearest ancestor in the view controller hierarchy that is a side panel controller.
@property (nonatomic, weak, readonly) TXSidePanelVC *sidePanelController;

@end
