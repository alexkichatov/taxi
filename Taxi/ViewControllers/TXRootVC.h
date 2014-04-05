//
//  TXRootVC.h
//  Taxi
//
//  Created by Irakli Vashakidze on 3/2/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXModelBase.h"
#import "TXBaseViewController.h"

@interface TXRootVC : TXBaseViewController<TXEventListener>

@property (nonatomic, strong) TXModelBase *model;
@property (nonatomic, strong) TXSharedObj *sharedObj;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void)setModel:(TXModelBase *) model_ eventNames:(NSArray *) eventNames;
-(void) pushViewController : (TXRootVC *) viewController;
-(void) alertError : (NSString *) title message : (NSString *) message;
-(TXRootVC *) viewControllerInstanceWithName: (NSString *) name;
@end
