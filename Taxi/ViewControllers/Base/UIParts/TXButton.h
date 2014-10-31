//
//  TXButton.h
//  Taxi
//
//  Created by Irakli Vashakidze on 10/30/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "UIUtil.h"

@interface TXButton : UIButton

- (id)initUnder:(UIView *) view dim:(float) pix;
- (id)initOnTopOf:(UIView *) view dim:(float) pix;

@end
