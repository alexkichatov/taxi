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
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 3.0;
    }
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
