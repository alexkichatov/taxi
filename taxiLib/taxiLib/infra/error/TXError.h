//
//  TXError.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/20/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXErrorCodes.h"

@interface TXError : NSObject

/*!
 @property errorCode
 */
@property(assign, nonatomic) int code;
/*!
 @property errorMessage message for the AMDCErrorObj
 */
@property(strong, nonatomic) NSString *message;
/*!
 @property errorMessage message for the AMDCErrorObj
 */
@property(strong, nonatomic) NSString *description;
/*!
 @property childErr AMDCErrorObj child error if it is specified
 */
@property(strong, nonatomic) TXError *childErr;

+(TXError*) error : (int) c message : (NSString *) msg description : (NSString *) desc;
+(TXError*) error : (int) c message : (NSString *) msg description : (NSString *) desc andChildError : (TXError *) childError;


@end
