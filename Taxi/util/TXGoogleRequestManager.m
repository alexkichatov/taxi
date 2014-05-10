//
//  TXGoogleAPIUtil.m
//  Taxi
//
//  Created by Irakli Vashakidze on 3/19/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXGoogleRequestManager.h"
#import "utils.h"
#import <GoogleMaps/GoogleMaps.h>
#import "StrConsts.h"

/* ===================== KEYWORDS ===================== */

static NSString* const K_JSON = @"JSON";
static NSString* const K_PREDICTIONS = @"predictions";
static NSString* const K_ID = @"id";
static NSString* const K_DESCRIPTION = @"description";

/* ===================== REQUESTS ===================== */

static NSString* const GOOGLE_KEY = @"AIzaSyA-mIDdBQDMjxoQ59UOpYnyqa0ogk9m7-M";

@implementation TXGoogleRequestManager {
    TXHttpRequestManager *httpMgr;
}



-(id)init {
    
    if(self=[super init]) {
        self->httpMgr = [TXHttpRequestManager instance];
    }
    
    return self;
}

-(BOOL) sendPlaceNearbySearchAsync:(NSString *) location radius:(NSString *)radius sensor:(BOOL) sensor rankBy:(NSString *)rankBy optional:(NSString *) parameters {
    if(location.length!=0 && radius.length!=0 && rankBy.length!=0) {
        
        location = [self getSpaceReplacedWithPrcnt20:location];
        
        NSMutableString *params = [NSMutableString stringWithFormat:@"key=%@", GOOGLE_KEY];
        [params appendFormat:@"&location=%@", location];
        [params appendFormat:@"&radius=%@", radius];
        [params appendFormat:@"&sensor=%@", (sensor == YES ? @"true" : @"false")];
        [params appendFormat:@"&rankby=%@", rankBy];
        
        if(parameters.length!=0) {
            [params appendFormat:@"&%@", parameters];
        }
        
        TXRequestObj* request = [TXRequestObj create:GoogleAPIRequestConsts.PLACES_NEARBYSEARCH urlParams:params listener:self];
        return [self sendAsyncRequest:request];
        
    } else {
        
        return NO;
        
    }
}

-(BOOL) sendPlaceTextSearchAsync:(NSString *) query sensor:(BOOL) sensor optional:(NSString *) parameters {
   
    if(query.length!=0) {
        
        query = [self getSpaceReplacedWithPrcnt20:query];
        
        NSMutableString *params = [NSMutableString stringWithFormat:@"key=%@", GOOGLE_KEY];
        [params appendFormat:@"&query=%@", query];
        [params appendFormat:@"&sensor=%@", (sensor == YES ? @"true" : @"false")];
        
        if(parameters.length!=0) {
            [params appendFormat:@"&%@", parameters];
        }
        
        TXRequestObj* request = [TXRequestObj create:GoogleAPIRequestConsts.PLACES_TEXTSEARCH urlParams:params listener:self];
        return [self sendAsyncRequest:request];
        
    } else {
        
        return NO;
        
    }
}

-(BOOL) sendPlaceRadarSearchAsync:(NSString *) location radius:(NSString *)radius sensor:(BOOL) sensor optional:(NSString *) parameters {
    
    if(location.length!=0 && radius.length!=0) {
        
        location = [self getSpaceReplacedWithPrcnt20:location];
        
        NSMutableString *params = [NSMutableString stringWithFormat:@"key=%@", GOOGLE_KEY];
        [params appendFormat:@"&location=%@", location];
        [params appendFormat:@"&radius=%@", radius];
        [params appendFormat:@"&sensor=%@", (sensor == YES ? @"true" : @"false")];
        
        if(parameters.length!=0) {
            [params appendFormat:@"&%@", parameters];
        }
        
        TXRequestObj* request = [TXRequestObj create:GoogleAPIRequestConsts.PLACES_RADARSEARCH urlParams:params listener:self];
        return [self sendAsyncRequest:request];
        
    } else {
        
        return NO;
        
    }
}

-(BOOL) sendPlaceAutocompleteAsync:(NSString *) input sensor:(BOOL) sensor optional:(NSString *) parameters {
    
    if(input.length!=0) {
        
        input = [self getSpaceReplacedWithPrcnt20:input];
        
        NSMutableString *params = [NSMutableString stringWithFormat:@"key=%@", GOOGLE_KEY];
        [params appendFormat:@"&input=%@", input];
        [params appendFormat:@"&sensor=%@", (sensor == YES ? @"true" : @"false")];
        
        if(parameters.length!=0) {
            [params appendFormat:@"&%@", parameters];
        }
        
        TXRequestObj* request = [TXRequestObj create:GoogleAPIRequestConsts.PLACES_AUTOCOMPLETE urlParams:params listener:self];
        return [self sendAsyncRequest:request];
        
    } else {
        
        return NO;
        
    }
}

-(BOOL) sendDirectionsByCoordinatesAsync:(double) startLat startLongitude:(double)startLng endLatitude:(double) endLat endLongitude:(double) endLng sensor:(BOOL) sensor optional:(NSString *) parameters {
    
    NSString *url = [NSString stringWithFormat:@"origin=%f,%f&destination=%f,%f&sensor=%@&%@&key=%@", startLat, startLng, endLat, endLng, (sensor == YES ? @"true" : @"false"), parameters, GOOGLE_KEY ];
    TXRequestObj *request = [TXRequestObj create:GoogleAPIRequestConsts.DIRECTIONS_BYCOORDINATES urlParams:url listener:self];
    return [self sendAsyncRequest:request];
    
}

-(BOOL) sendDirectionsByCoordinatesAsync:(double) startLat startLongitude:(double)startLng endLocation:(NSString *) endLocation sensor:(BOOL) sensor optional:(NSString *) parameters {
    
    if(endLocation.length!=0) {
        
        endLocation = [self getSpaceReplacedWithPrcnt20:endLocation];
        
        NSMutableString *params = [NSMutableString stringWithFormat:@"key=%@", GOOGLE_KEY];
        [params appendFormat:@"&origin=%f,%f", startLat, startLng];
        [params appendFormat:@"&destination=%@", endLocation];
        [params appendFormat:@"&sensor=%@", (sensor == YES ? @"true" : @"false")];
        
        if(parameters.length!=0) {
            [params appendFormat:@"&%@", parameters];
        }
        
        TXRequestObj* request = [TXRequestObj create:GoogleAPIRequestConsts.DIRECTIONS_BYCOORDINATES urlParams:params listener:self];
        return [self sendAsyncRequest:request];
        
    } else {
        
        return NO;
        
    }
    
}

-(void)onRequestCompleted:(id)object {
    
    TXRequestObj *request  = (TXRequestObj *)object;
    NSString     *response = [[NSString alloc] initWithData:request.receivedData encoding:NSUTF8StringEncoding];
    id           jsonObj   = getJSONObj(response);
    id           prop      = nil;
    NSString     *evtName  = nil;
    
    if([request.reqConfig.name isEqualToString:GoogleAPIRequestConsts.PLACES_AUTOCOMPLETE]) {

        NSArray *predictions = [jsonObj objectForKey:K_PREDICTIONS];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[predictions count]];
        
        for (NSDictionary *pred in predictions) {
            
            TXPrediction *prediction = [TXPrediction create];
            prediction.id_ = [pred objectForKey:K_ID];
            prediction.description = [pred objectForKey:K_DESCRIPTION];
            
            [array addObject:prediction];
            
        }
        
        evtName = TXEvents.GOOGLE_PLACES_AUTOCOMP_REQ_COMPLETED;
        prop = array;
        
    } else if ([request.reqConfig.name isEqualToString:GoogleAPIRequestConsts.DIRECTIONS_BYCOORDINATES]) {
        
        NSDictionary *responseObj = getJSONObj([[NSString alloc] initWithData:request.receivedData encoding:NSUTF8StringEncoding]);
        NSArray *routes = [(NSDictionary*)responseObj objectForKey:@"routes"];
        NSArray *legs = [[routes objectAtIndex:0] objectForKey:@"legs"];
        
        NSDictionary *distance = [legs[0] objectForKey:@"distance"];
        NSString *text = [distance objectForKey:@"text"];
        long value = [[distance objectForKey:@"value"] longValue];
        
        evtName = TXEvents.GOOGLE_DIRECTIONS_REQ_COMPLETED;
        prop = @{ @"description" : text, @"distance" : [NSNumber numberWithLong:value] };
    }
    
    [self fireEvent:[TXEvent createEvent:evtName eventSource:self eventProps:@{ TXEvents.Params.GOOGLEOBJECT : prop  }]];
}

-(void)onFail:(id)object error:(TXError *)error {
    
}

+(GMSPolyline *)polylineWithEncodedString:(NSString *)encodedString {
    
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
    
    GMSMutablePath *path = [[GMSMutablePath alloc] init];
    
    int i;
    for (i = 0; i < coordIdx; i++)
    {
        [path addCoordinate:coords[i]];
    }
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    free(coords);
    
    return polyline;
}




-(NSString *) getSpaceReplacedWithPrcnt20:(NSString *) source {
    return [source stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
}

-(BOOL) sendAsyncRequest:(TXRequestObj *) request {
    return [self->httpMgr sendAsyncRequest:request];
}


@end
