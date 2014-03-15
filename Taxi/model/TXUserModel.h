//
//  TXUserModel.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXUser.h"
#import "TXModelBase.h"

@interface TXUserModel : TXModelBase

/** Creates the single instance within the application
 
 @return TXUserModel
 */
+(TXUserModel *) instance;
-(void) registerUser : (TXUser *) user;
-(void) login : (NSString *) username andPass : (NSString *) pwd;
-(void) loginWithProvider:(TXUser *) user;
-(void) update : (TXUser *) user;
-(void) deleteUser;
-(void) logout;

@end
