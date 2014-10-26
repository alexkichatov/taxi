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

//@property (nonatomic, assign) int       objID;
@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* surname;
@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSString* mobile;
@property (nonatomic, assign) int       statusID;
@property (nonatomic, retain) NSString* note;
@property (nonatomic, retain) NSDate  * createDate;
@property (nonatomic, retain) NSDate  * modificationDate;
@property (nonatomic, retain) NSString* language;
@property (nonatomic, retain) NSString* photoURL;
@property (nonatomic, retain) NSString* providerUserID;
@property (nonatomic, retain) NSString* providerID;
@property (nonatomic, assign) BOOL      isConfirmed;
//@property (nonatomic, retain) NSString* userToken;

@end

@interface TXUserModel : TXModelBase

/** Creates the single instance within the application
 
 @return TXUserModel
 */
+(TXUserModel *) instance;
-(void) signUp:(TXUser *)user;
-(void) signIn:(NSString *)username password:(NSString *)password providerId:(NSNumber *) providerId providerUserId:(NSString*)providerUserId;
-(void) authWithToken:(NSString *) userToken;
-(void) update : (TXUser *) user;
-(void) deleteUser;
-(void) logout;
-(void) checkIfUserExists:(TXUser *) user;
-(void) checkIfPhoneNumberBlocked:(NSString *) phoneNum loginWithProvider: (BOOL) loginWithProvider;
-(void) confirm:(int) userId code:(NSString *) code;
-(void) resendVerificationCode:(int) userId;
-(void) updateMobile:(int) userId mobile:(NSString *)mobile;

@end
