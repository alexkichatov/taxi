//
//  TXButton.m
//  Taxi
//
//  Created by Irakli Vashakidze on 10/30/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXButton.h"

@implementation TXButton

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    if(self = [super initWithCoder:aDecoder]) {
        
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 3.0;
        self.alpha = 0.8f;
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
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

- (id)initOnTopOf:(UIView *) view dim:(float) pix;
{
    self = [self initWithFrame:view.frame];
    
    if(self) {
        
        CGRect viewFrame = view.frame;
        self.frame = CGRectMake(viewFrame.origin.x,
                                (viewFrame.origin.y - viewFrame.size.height - pix),
                                viewFrame.size.width,
                                viewFrame.size.height);
        
    }
    
    return self;
    
}

@end
