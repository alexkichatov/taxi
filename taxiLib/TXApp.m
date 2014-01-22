//
//  TXApp.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/19/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXApp.h"
#import "TXHttpRequestManager.h"
#import "UIKit/UIDevice.h"

@interface TXApp()<TXHttpRequestListener> {
    TXSettings *settings;
    NSString   *sysVersion;
}

-(id)init;

@end

@implementation TXApp

+(TXApp*) instance {
    static dispatch_once_t pred;
    static TXApp* _instance;
    dispatch_once(&pred, ^{ _instance = [[self alloc] init]; });
    return _instance;
}

-(id)init {
    
    self = [super init];
    if(self !=nil) {
        self->sysVersion = [UIDevice currentDevice].systemVersion;
    }
    
    return self;
}

-(TXSettings*)getSettings {
    
    if ( self->settings == nil ) {
        self->settings = [TXSettings instance];
    }
    return self->settings;
}

-(void)onRequestCompleted:(id)object {
    
}

-(void)onFail:(id)object error:(TXError *)error {
    
}

@end
