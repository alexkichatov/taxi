//
//  TXSettings.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/22/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXSettings : NSObject {
    NSString*               stgPath;
    NSMutableDictionary*    root;           //main storage, gets recorded in the local file. Holds user settings as well.
    
}

/*!
 @function instance Convenience function to obtain settings singleton object
 @return TXSettings object
 */
+(TXSettings*) instance;

/*!
 @function saveSettings Saves settings to the storage.
 @return void
 */
-(void)saveSettings;

-(void)initWithDefaults;

-(void)initWithObject:(NSDictionary*)userProfile;

/*!
 @function setProperty Set the value of a property
 @param property The name of the property to set
 @param value The value for the property
 @return void
 */
-(void)setProperty:(NSString*)property value:(id)value;

/*!
 @function getProperty Get the value of a property
 @param property The name of the property to get
 @return The value for the property
 */
-(id)getProperty:(NSString*)property;

-(NSString*)getUserName;
-(NSString*)getPassword;

-(void)setUserName:(NSString*)userName;
-(void)setPassword:(NSString*)pwd;

-(void)setUserToken:(NSString *)token;
-(NSString *)getUserToken;

-(void) setNotificationsToken : (NSString *)token;
-(NSString*)getNotificationsToken;

-(void) setGoogleUserId : (NSString *)userId;
-(NSString*)getGoogleUserId;
-(void) setFBUserId : (NSString *)userId;
-(NSString*)getFBUserId;

-(int) getMaxHTTPConnectionsNumber;

@end
