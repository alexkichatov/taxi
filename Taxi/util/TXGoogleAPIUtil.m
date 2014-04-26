//
//  TXGoogleAPIUtil.m
//  Taxi
//
//  Created by Irakli Vashakidze on 3/19/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXGoogleAPIUtil.h"
#import "TXGoogleAPIReqManager.h"
#import "taxiLib/utils.h"

@implementation TXGoogleAPIUtil {
    TXGoogleAPIReqManager *googleMgr;
}



-(id)init {
    
    if(self=[super init]) {
        self->googleMgr = [[TXGoogleAPIReqManager alloc] initWithListener:self];
    }
    
    return self;
}

-(BOOL) sendPlaceNearbySearchRequest:(NSString *) location radius:(NSString *)radius sensor:(BOOL) sensor rankBy:(NSString *)rankBy optional:(NSString *) parameters {
    return NO; //[self->googleMgr sendPlaceNearbySearchRequest:location radius:radius sensor:sensor rankBy:rankBy optional:parameters];
}

-(BOOL) sendPlaceTextSearchRequest:(NSString *) query sensor:(BOOL) sensor optional:(NSString *) parameters {
    return NO; //[self->googleMgr sendPlaceTextSearchRequest:query sensor:sensor optional:parameters];
}

-(BOOL) sendPlaceRadarSearchRequest:(NSString *) location radius:(NSString *)radius sensor:(BOOL) sensor optional:(NSString *) parameters {
    return NO; //[self->googleMgr sendPlaceRadarSearchRequest:location radius:radius sensor:sensor optional:parameters];
}

-(BOOL) sendPlaceAutocompleteRequest:(NSString *) input sensor:(BOOL) sensor optional:(NSString *) parameters {
    return NO; //[self->googleMgr sendPlaceAutocompleteRequest:input sensor:sensor optional:parameters];
}

-(void)onRequestCompleted:(id)object {
    
    TXRequestObj *request = (TXRequestObj *)object;
    
    NSString *response = [[NSString alloc] initWithData:request.receivedData encoding:NSUTF8StringEncoding];
    id jsonObj = getJSONObj(response);
    
    NSLog(@"%@", jsonObj);
    
    [self fireEvent:[TXEvent createEvent:@"onGoogleRequestCompleted" eventSource:self eventProps:@{ @"JSON" : jsonObj  }]];
}

-(void)onFail:(id)object error:(TXError *)error {
    
}

@end
