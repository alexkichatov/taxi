//
//  TXCallModel.h
//  Taxi
//
//  Created by Irakli Vashakidze on 5/10/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXModelBase.h"

@interface TXCallModel : TXModelBase

/** Creates the single instance within the application
 
 @return TXCallModel
 */
+(TXCallModel *) instance;

-(void) requestChargeForCountry:(NSString *) country distance:(long) distance;

@end
