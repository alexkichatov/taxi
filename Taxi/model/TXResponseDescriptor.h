//
//  TXResponseDescriptor.h
//  Taxi
//
//  Created by Irakli Vashakidze on 10/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXResponseDescriptor : NSObject

@property (nonatomic, assign) BOOL      success;
@property (nonatomic, assign) int       code;
@property (nonatomic, weak)   NSString* message;
@property (nonatomic, weak)   id        source;

+(id) create:(BOOL) succcess_ code:(int) code_ message:(NSString *) message_ source:(id) source_;
+(id) create:(BOOL) succcess_ code:(int) code_;

@end
