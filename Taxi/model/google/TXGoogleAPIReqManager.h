//
//  TXGoogleAPIReqManager.h
//  taxiLib
//
//  Created by Irakli Vashakidze on 3/19/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXHttpRequestManager.h"

@interface TXGoogleAPIReqManager : NSObject

-(id)initWithListener:(id<TXHttpRequestListener>) listener_;
-(BOOL) searchNearyyAsync:(NSString *) location radius:(NSString *)radius sensor:(BOOL) sensor rankBy:(NSString *)rankBy optional:(NSString *) parameters;
-(BOOL) placeAutocompleteAsync:(NSString *) input sensor:(BOOL) sensor optional:(NSString *) parameters;
-(BOOL) searchPlaceByTextAsync:(NSString *) query sensor:(BOOL) sensor optional:(NSString *) parameters;
-(BOOL) searchPlaceByRadarAsync:(NSString *) location radius:(NSString *)radius sensor:(BOOL) sensor optional:(NSString *) parameters;
-(BOOL) directionsByCoordinatesAsync:(double) startLat startLongitude:(double)startLng endLatitude:(double) endLat endLongitude:(double) endLng sensor:(BOOL) sensor optional:(NSString *) parameters;
@end
