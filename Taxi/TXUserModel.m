//
//  TXUserModel.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXUserModel.h"
#import "taxiLib/utils.h"
#import "TXConsts.h"

static NSString* const XCL_PROP_OBJID = @"objId";
static NSString* const XCL_PROP_STATUSID = @"statusId";

@implementation TXUserModel

/** Creates the single instance within the application
 
 @return TXUserModel
 */
+(TXUserModel *) instance {
    static dispatch_once_t pred;
    static TXUserModel* _instance;
    dispatch_once(&pred, ^{ _instance = [[self alloc] init]; });
    return _instance;
}

-(void)registerUser:(TXUser *)user {
    
    TXRequestObj *request = [TXRequestObj initWithConfig:@"register" andListener:nil];
    
    NSMutableDictionary *propertyMap = [[user propertyMap] mutableCopy];
    [propertyMap removeObjectForKey:XCL_PROP_OBJID];
    [propertyMap removeObjectForKey:XCL_PROP_STATUSID];
    
    NSDictionary *jsonObj = @{
                                        API_JSON.Keys.ATTR  : [NSNull null],
                                        API_JSON.Keys.DATA  : propertyMap
                                      };
    
    request.body = getJSONStr(jsonObj);
    [self->httpMgr sendSyncRequest:request];
    
}

-(void)login:(NSString *)username andPass:(NSString *)pwd {
    
}

-(void)logout {
    
}

-(void)update:(TXUser *)user {
    
}

-(void)onRequestCompleted:(id)object {
    
}

-(void)onFail:(id)object error:(TXError *)error {
    
}

@end
