//
//  TXTextField.h
//  Taxi
//
//  Created by Irakli Vashakidze on 10/28/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "UIUtil.h"

@interface TXTextField : UITextField

@property (nonatomic, assign) float height;
@property (nonatomic, assign) float width;

- (id)initUnder:(UIView *) view dim:(float) pix;

@end
