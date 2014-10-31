//
//  TXTextField.m
//  Taxi
//
//  Created by Irakli Vashakidze on 10/28/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXTextField.h"

@implementation TXTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.borderStyle = UITextBorderStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.9f;
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.font = [UIFont systemFontOfSize:15];
        self.placeholder = @"Enter text";
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.keyboardType = UIKeyboardTypeDefault;
        self.returnKeyType = UIReturnKeyDone;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
    }
    return self;

}

- (id)initUnder:(UIView *) view dim:(float) pix;
{
    
    self = [self initWithFrame:view.frame];
    
    if(self) {
        
        CGRect viewFrame = view.frame;
        self.frame = CGRectMake(viewFrame.origin.x,
                                (viewFrame.origin.y + viewFrame.size.height + pix),
                                viewFrame.size.width,
                                viewFrame.size.height);
        
    }
    
    return self;
    
}

-(void)setHeight:(float)height {
    CGRect frameRect = self.frame;
    frameRect.size.height = height;
    self.frame = frameRect;
}

-(void)setWidth:(float)width {
    CGRect frameRect = self.frame;
    frameRect.size.width = width;
    self.frame = frameRect;
}

@end
