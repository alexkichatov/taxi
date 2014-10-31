//
//  util.m
//  Taxi
//
//  Created by Irakli Vashakidze on 11/1/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "util.h"

UIColor* colorFromRGB(float R, float G, float B, float alpha) {
    return [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:alpha];
}