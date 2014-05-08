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

@interface TXGoogleObjectsCache : NSObject

/** Creates the single instance within the application
 
 @return TXGoogleObjectsCache
 */
+(TXGoogleObjectsCache *) instance;
-(void) cachePredictions:(NSString *) srcStr predictions:(NSArray *) predictions;
-(NSArray *) predictionsFromCache:(NSString *) srcStr;
-(void) clearPredictionsCache;

@end
