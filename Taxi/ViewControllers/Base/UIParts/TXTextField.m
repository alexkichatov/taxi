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
        // Initialization code
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
