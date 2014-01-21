//
//  TXError.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/20/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXError.h"

@interface TXError()

-(id) initWithParams : (int) c andMsg : (NSString *)msg andDesc : (NSString *) desc andChildError : (TXError *) childError;

@end

@implementation TXError

@synthesize code, message, description, childErr;

+(TXError*) error : (int) c message : (NSString *) msg description : (NSString *) desc {
    return [[TXError alloc] initWithParams:c andMsg:msg andDesc:desc andChildError:nil];
}

+(TXError*) error : (int) c message : (NSString *) msg description : (NSString *) desc andChildError : (TXError *) childError {
    return [[TXError alloc] initWithParams:c andMsg:msg andDesc:desc andChildError:childError];
}

/* Internal instance method for init */
-(id) initWithParams : (int) c andMsg : (NSString *)msg andDesc : (NSString *) desc andChildError : (TXError *) childError {
    self = [super init];
    if(self!=nil) {
        self.code = c;
        self.message = msg;
        self.description = desc;
        self.childErr = childError;
    }
    
    return self;
}

@end
