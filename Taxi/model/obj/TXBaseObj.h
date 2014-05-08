//
//  TXBaseObj.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXPropertyConsts.h"

@interface TXBaseObj : NSObject

+(id)create;
+(id)create:(NSDictionary *) properties;
-(NSDictionary *) getProperties;
-(void) setProperties : (NSDictionary *) props;

@end
