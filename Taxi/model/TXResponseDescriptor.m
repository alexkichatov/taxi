//
//  TXResponseDescriptor.m
//  Taxi
//
//  Created by Irakli Vashakidze on 10/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXResponseDescriptor.h"

@implementation TXResponseDescriptor

-(id) init:(BOOL) succcess_ code:(int) code_ message:(NSString *) message_ source:(id) source_ {
    if(self = [super init]) {
        self.success = succcess_;
        self.code    = code_;
        self.message = message_;
        self.source  = source_;
    }
    
    return self;
}


+(id) create:(BOOL) succcess_ code:(int) code_ message:(NSString *) message_ source:(id) source_ {
    return [[self alloc] init:succcess_ code:code_ message:message_ source:source_];
}

+(id) create:(BOOL) succcess_ code:(int) code_ {
    return [self create:succcess_ code:code_ message:nil source:nil];
}

@end
