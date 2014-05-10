//
//  TXGoogleAPIUtil.h
//  Taxi
//
//  Created by Irakli Vashakidze on 3/19/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXHttpRequestManager.h"
#import "TXEventTarget.h"
#import "TXGoogleObjectsCache.h"

extern NSString const *EVENT_PROPERTY;

@class GMSPolyline;

@interface TXGoogleRequestManager : TXEventTarget<TXHttpRequestListener>

-(BOOL) sendPlaceNearbySearchAsync:(NSString *) location radius:(NSString *)radius sensor:(BOOL) sensor rankBy:(NSString *)rankBy optional:(NSString *) parameters;
-(BOOL) sendPlaceTextSearchAsync:(NSString *) query sensor:(BOOL) sensor optional:(NSString *) parameters;
-(BOOL) sendPlaceRadarSearchAsync:(NSString *) location radius:(NSString *)radius sensor:(BOOL) sensor optional:(NSString *) parameters;
-(BOOL) sendPlaceAutocompleteAsync:(NSString *) input sensor:(BOOL) sensor optional:(NSString *) parameters;
-(BOOL) sendDirectionsByCoordinatesAsync:(double) startLat startLongitude:(double)startLng endLatitude:(double) endLat endLongitude:(double) endLng sensor:(BOOL) sensor optional:(NSString *) parameters;
-(BOOL) sendDirectionsByCoordinatesAsync:(double) startLat startLongitude:(double)startLng endLocation:(NSString *) endLocation sensor:(BOOL) sensor optional:(NSString *) parameters;
+(GMSPolyline *)polylineWithEncodedString:(NSString *)encodedString;

@end
