//
//  TXBaseObj.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXBaseObj.h"
#import <objc/runtime.h>

@implementation TXBaseObj

+(id)create {
    return [[self alloc] init];
}

+(id)create:(NSDictionary *)properties {
    return [[self alloc] initWithProperties:properties];
}

-(id) initWithProperties : (NSDictionary *) properties {
    
    if(self = [super init]) {
        [self setProperties:properties];
    }
    
    return self;
}

-(NSDictionary *) getProperties {
    
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

-(void) setProperties : (NSDictionary *) props {

    NSArray *keys = [props allKeys];
    
    for (NSString *key in keys) {
        [self setValue:[props objectForKey:key] forKey:key];
    }
    
}

@end
