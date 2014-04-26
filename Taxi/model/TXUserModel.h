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
-(TXSyncResponseDescriptor *)signUp:(TXUser *)user;
-(void) login : (NSString *) username andPass : (NSString *) pwd;
-(TXSyncResponseDescriptor *)loginWithProvider:(TXUser *) user;
-(void) update : (TXUser *) user;
-(void) deleteUser;
-(void) logout;
-(void) checkIfUserExists:(NSString *) username providerId: (NSString *) providerId providerUserId:(NSString *) providerUserId;
-(TXSyncResponseDescriptor *)checkIfPhoneNumberBlocked:(NSString *) phoneNum loginWithProvider: (BOOL) loginWithProvider;

@end
