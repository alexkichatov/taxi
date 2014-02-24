//
//  TXVCSharedUtil.m
//  Taxi
//
//  Created by Irakli Vashakidze on 2/24/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXVCSharedUtil.h"

@interface TXVCSharedUtil(){
    UIStoryboard *iPhoneStoryBoard;
    UIStoryboard *iPadStoryBoard;
}

@end

@implementation TXVCSharedUtil

+(TXVCSharedUtil*) instance {
    static dispatch_once_t pred;
    static TXVCSharedUtil* _instance;
    dispatch_once(&pred, ^{ _instance = [[self alloc] init]; });
    return _instance;
}

-(id)init {
    
    if(self = [super init]) {
        self->iPhoneStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
        self->iPadStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle: nil];
    }
    
    return self;
}

-(UIStoryboard *)iPhoneStoryBoard {
    return self->iPhoneStoryBoard;
}

-(UIStoryboard *)iPadStoryBoard {
    return self->iPadStoryBoard;
}

@end
