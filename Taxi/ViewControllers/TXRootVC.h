//
//  TXRootVC.h
//  Taxi
//
//  Created by Irakli Vashakidze on 3/2/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXModelBase.h"

@interface TXRootVC : UIViewController<TXEventListener> {
    TXModelBase* model;
}

-(void)setModel:(TXModelBase *) model_ eventNames:(NSArray *) eventNames;

@end
