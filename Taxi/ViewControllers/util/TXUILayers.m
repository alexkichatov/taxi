//
//  TXUILayers.m
//  Taxi
//
//  Created by Irakli Vashakidze on 6/25/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXUILayers.h"

@implementation TXUILayers

+(CAShapeLayer *) layerWithRadiusTop:(CGRect) bounds color:(CGColorRef) color {
    
    UIBezierPath *mask = [UIBezierPath bezierPathWithRoundedRect:bounds
                                       byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                       cornerRadii:CGSizeMake(3.0, 3.0)];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = bounds;
    layer.path = mask.CGPath;
    [layer setFillColor:color];
    
    return layer;
}

+(CAShapeLayer *) layerWithRadiusBottom:(CGRect) bounds color:(CGColorRef) color {
    
    UIBezierPath *mask = [UIBezierPath bezierPathWithRoundedRect:bounds
                                       byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                       cornerRadii:CGSizeMake(3.0, 3.0)];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = bounds;
    layer.path = mask.CGPath;
    layer.shadowColor = [UIColor blackColor].CGColor;
    [layer setFillColor:color];
    
    return layer;
}

+(CAShapeLayer *) layerWithRadiusNone:(CGRect) bounds color:(CGColorRef) color {
    
    UIBezierPath *mask = [UIBezierPath bezierPathWithRoundedRect:bounds
                                               byRoundingCorners:false
                                                     cornerRadii:CGSizeMake(3.0, 3.0)];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = bounds;
    layer.path = mask.CGPath;
    [layer setFillColor:color];
    
    return layer;
}


@end
