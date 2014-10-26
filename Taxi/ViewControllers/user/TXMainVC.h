//
//  TXMainVC.h
//  Taxi
//
//  Created by Irakli Vashakidze on 4/2/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXRootVC.h"
#import "SlideNavigationController.h"

@interface TXMainVC : TXRootVC<SlideNavigationControllerDelegate>

- (id)initWithToken:(NSString *) token;

@end
