//
//  TXBaseObj.m
//  taxiLib
//
//  Created by Irakli Vashakidze on 1/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXBaseObj.h"
#import <objc/runtime.h>

@implementation TXBaseObj

-(NSDictionary *) propertyMap {
    
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([self class], &propertyCount);
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:propertyCount];
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        NSString *name   = [NSString stringWithUTF8String:property_getName(property)];
        NSObject *value  = [self valueForKey:name];
        if(value != nil) {
            [result setObject:value forKey:name];
        } else {
            [result setObject:[NSNull null] forKey:name];
        }
        
    }
    free(properties);
    
    return result;
}


@end
