//
//  TXRootVC.h
//  Taxi
//
//  Created by Irakli Vashakidze on 3/2/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXCode2MsgTranslator.h"
#import "TXModelBase.h"
#import "TXBaseViewController.h"
#import "TXStackedViewController.h"

@interface TXRootVC : TXStackedViewController<TXEventListener> {
    NSDictionary *parameters;
}

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void) pushViewController : (TXRootVC *) viewController;
-(void) alertError : (NSString *) title message : (NSString *) message;
-(TXRootVC *) viewControllerInstanceWithName: (NSString *) name;
-(TXRootVC *) viewControllerInstanceFromClass: (Class) aClass;
-(void)refreshInterfaceBasedOnSignIn;
-(void) setParameters:(NSDictionary *)props;
@end
