//
//  TXUserModel.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXBaseObj.h"
#import "TXModelBase.h"

@interface TXUser : TXBaseObj

@property (nonatomic, assign) int       objId;
@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* surname;
@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSString* mobile;
@property (nonatomic, assign) int       statusId;
@property (nonatomic, retain) NSString* note;
@property (nonatomic, retain) NSDate  * createDate;
@property (nonatomic, retain) NSDate  * modificationDate;
@property (nonatomic, retain) NSString* language;
@property (nonatomic, retain) NSString* photoURL;
@property (nonatomic, retain) NSString* providerUserId;
@property (nonatomic, retain) NSString* providerId;

@end

@interface TXUserModel : TXModelBase

/** Creates the single instance within the application
 
 @return TXUserModel
 */
+(TXUserModel *) instance;
-(TXSyncResponseDescriptor *)signUp:(TXUser *)user;
-(TXSyncResponseDescriptor *)signIn:(TXUser *)user;
-(void) update : (TXUser *) user;
-(void) deleteUser;
-(void) logout;
-(void)checkIfUserExistsAsync:(TXUser *) user;
-(TXSyncResponseDescriptor *)checkIfUserExistsSync:(TXUser *) user;
-(TXSyncResponseDescriptor *)checkIfPhoneNumberBlocked:(NSString *) phoneNum loginWithProvider: (BOOL) loginWithProvider;
-(TXSyncResponseDescriptor *)confirm:(int) userId code:(NSString *) code;
-(TXSyncResponseDescriptor *)resendVerificationCode:(int) userId;
-(TXSyncResponseDescriptor *)updateMobile:(int) userId mobile:(NSString *)mobile;

@end
