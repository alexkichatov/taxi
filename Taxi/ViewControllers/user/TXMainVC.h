//
//  TXMainVC.h
//  Taxi
//
//  Created by Irakli Vashakidze on 4/2/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXBaseViewController.h"
#import "SlideNavigationController.h"

@interface TXMainVC : TXBaseViewController<SlideNavigationControllerDelegate>

- (id)initWithToken:(NSString *) token;

@end
