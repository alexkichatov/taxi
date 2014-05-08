//
//  TXApp.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/19/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXApp.h"
#import "UIKit/UIDevice.h"

@interface TXApp() {
    TXSettings *settings;
    NSString   *sysVersion;
    NSString   *deviceUID;
    NSString   *model;
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
        
        UIDevice *device = [UIDevice currentDevice];
        
        self->sysVersion = device.systemVersion;
        self->deviceUID  = [[device identifierForVendor] UUIDString];
        self->model      = device.model;
        self->settings = [TXSettings instance];
    }
    
    return self;
}

-(TXSettings*)getSettings {
    return self->settings;
}

-(NSString *)getDeviceUID {
    return self->deviceUID;
}

-(NSString *) getDeviceModel {
    return self->model;
}

-(NSString *)getSystemVersion {
    return self->sysVersion;
}

@end
