//
//  TXGoogleAPI.h
//  Taxi
//
//  Created by Irakli Vashakidze on 5/8/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXGoogleObj : NSObject

+(id)create;

@end

@interface TXPrediction : TXGoogleObj

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *id_;

@end

@interface TXGoogleAPI : NSObject

@end
