//
//  TXUserModel.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXBaseObj.h"
#import "TXModelBase.h"

extern const struct UserConsts {
    
    __unsafe_unretained NSString* USERNAME;
    __unsafe_unretained NSString* PASSWORD;
    __unsafe_unretained NSString* NAME;
    __unsafe_unretained NSString* SURNAME;
    __unsafe_unretained NSString* EMAIL;
    __unsafe_unretained NSString* MOBILE;
    __unsafe_unretained NSString* STATUSID;
    __unsafe_unretained NSString* NOTE;
    __unsafe_unretained NSString* CREATEDATE;
    __unsafe_unretained NSString* MODIFICATIONDATE;
    __unsafe_unretained NSString* LANGUAGE;
    __unsafe_unretained NSString* PHOTOURL;
    __unsafe_unretained NSString* PROVIDERUSERID;
    __unsafe_unretained NSString* PROVIDERID;
    __unsafe_unretained NSString* ISCONFIRMED;
    __unsafe_unretained NSString* USERTOKEN;
    
} UserConsts;

@interface TXUser : TXBaseObj

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
@property (nonatomic, retain) NSString* userToken;

@end

@interface TXUserModel : TXModelBase

/** Creates the single instance within the application
 
 @return TXUserModel
 */
+(TXUserModel *) instance;
-(void) signUp:(TXUser *)user;
-(void) signIn:(NSString *)username password:(NSString *)password providerId:(NSNumber *) providerId providerUserId:(NSString*)providerUserId;
-(void) signIn:(TXUser *) user;
-(void) authWithToken:(NSString *) userToken;
-(void) update : (TXUser *) user;
-(void) deleteUser;
-(void) logout;
-(void) checkIfUserExists:(TXUser *) user;
-(void) checkIfPhoneNumberBlocked:(NSString *) phoneNum loginWithProvider: (BOOL) loginWithProvider;
-(void)confirm:(int) userId code:(int) code;
-(void) resendVerificationCode:(int) userId;
-(void) updateMobile:(int) userId mobile:(NSString *)mobile;

@end
