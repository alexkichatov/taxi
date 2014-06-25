//
//  TXUILayers.h
//  Taxi
//
//  Created by Irakli Vashakidze on 6/25/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXUILayers : NSObject

+(CAShapeLayer *) layerWithRadiusTop:(CGRect) bounds color:(CGColorRef) color;
+(CAShapeLayer *) layerWithRadiusBottom:(CGRect) bounds color:(CGColorRef) color;
+(CAShapeLayer *) layerWithRadiusNone:(CGRect) bounds color:(CGColorRef) color;

@end
