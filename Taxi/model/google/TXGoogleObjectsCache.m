//
//  TXGoogleAPI.m
//  Taxi
//
//  Created by Irakli Vashakidze on 5/8/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXGoogleObjectsCache.h"

@implementation TXGoogleObj

+(id)create {
    return [[self alloc] init];
}

@end

@implementation TXPrediction

@end

@interface TXGoogleObjectsCache() {
    NSMutableDictionary *predictionCache;
}

@end

@implementation TXGoogleObjectsCache

/** Creates the single instance within the application
 
 @return TXGoogleObjectsCache
 */
+(TXGoogleObjectsCache *) instance {
    static dispatch_once_t pred;
    static TXGoogleObjectsCache* _instance;
    dispatch_once(&pred, ^{ _instance = [[self alloc] init]; });
    return _instance;
}

-(id)init {
    
    if(self = [super init]) {
        self->predictionCache = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    return self;
    
}

-(void) cachePredictions:(NSString *) srcStr predictions:(NSArray *) predictions {
    [self->predictionCache setObject:srcStr forKey:predictions];
}

-(NSArray *) predictionsFromCache:(NSString *) srcStr {
    return [self->predictionCache objectForKey:srcStr];
}

-(void) clearPredictionsCache {
    [self->predictionCache removeAllObjects];
}

@end
