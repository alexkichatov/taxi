//
//  TXSettings.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/22/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXSettings.h"
#import "StrConsts.h"
#import "Macro.h"
#import "TXError.h"
#import "FDKeyChain.h"

static NSString* const HTTPAPI_PLIST_FILE = @"httpapi";

@interface TXSettings()

-(TXSettings*)init;

-(void)initWithDefaults;
-(void)initWithObject:(NSDictionary*)userProfile;
-(void)onRequestCompleted:(id)object;
-(void)onFail:(id)object error:(TXError *)error;

@end

@implementation TXSettings

+(TXSettings *) instance {
    static dispatch_once_t settingsPred;
    static TXSettings* _settingsInstance;
    dispatch_once(&settingsPred, ^{ _settingsInstance = [[self alloc] init]; });
    return _settingsInstance;
}


-(id) init {
	self = [super init];
	if ( self ) {
        NSURL* t = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
		self->stgPath = [[t URLByAppendingPathComponent:Files.SETTINGSFILE] path];
		NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:stgPath];
        
		NSPropertyListFormat format;
		NSString *errorString;
		self->root = [NSPropertyListSerialization propertyListFromData:plistXML
                                                mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                          format:&format
                                                errorDescription:&errorString];
		if (self->root == nil) {
            self->root = [[NSMutableDictionary alloc] initWithCapacity:10];
            [self initWithDefaults];
		}
        
	}
	return self;
}

-(void)saveSettings {
    [root writeToFile:self->stgPath atomically:YES];
}

-(void)initWithDefaults {
    
    [self setProperty:SettingsConst.Property.BASEURL value:@"http://localhost"]; // Me
    [self setProperty:SettingsConst.Property.PORT value:@"8080"];

//    [self setProperty:SettingsConst.Property.BASEURL value:@"http://192.168.1.31"]; // Archvi
//    [self setProperty:SettingsConst.Property.PORT value:@"8081"];
    
//    [self setProperty:SettingsConst.Property.BASEURL value:@"http://46.49.122.152"]; // Server
//    [self setProperty:SettingsConst.Property.PORT value:@"8080"];
    
    [self setUserName:@"tomcat"];
    [self setPassword:@"tomcat"];
    
    NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:Files.BUNDLE_PATH];
    NSBundle *thisBundle = [NSBundle bundleWithPath:path];
    NSString *plistPath = [thisBundle pathForResource:HTTPAPI_PLIST_FILE ofType:@"plist"];
    NSDictionary* rootObj = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    [self setProperty:SettingsConst.Property.HTTP_API value:rootObj];
    
}

//receives server side parameters for the user, for initial settings will have default user settings, and admin settings
-(void)initWithObject:(NSDictionary*)userProfile {
    for (NSString *key in [userProfile keyEnumerator]) {
        [self setProperty:key value:[userProfile objectForKey:key]];
    }
}

-(void)setProperty:(NSString*)property value:(id)value {
    
    if ( [property length] > 0 && value != nil ) {
        [self->root setObject:value forKey:property];
    }
}

-(id)getProperty:(NSString*)property {
    if ( [property length] > 0 )
        return [self->root objectForKey:property];
    DLogE(@"Illegal parameter, empty key name!");
    return nil;
    
    return [NSNull null];
}

-(NSString*)getUserName {
    return [FDKeychain itemForKey:SettingsConst.CryptoKeys.USERNAME
                       forService:SettingsConst.TXCRYPTOSVC_GENERIC];
}

-(NSNumber*)getUserId {
    return [FDKeychain itemForKey:SettingsConst.CryptoKeys.USERID
                       forService:SettingsConst.TXCRYPTOSVC_GENERIC];
}

-(NSString*)getPassword {
    return [FDKeychain itemForKey:SettingsConst.CryptoKeys.PASSWORD
                       forService:SettingsConst.TXCRYPTOSVC_GENERIC];
}

-(void)setUserName:(NSString*)userName {
    [FDKeychain saveItem:userName forKey:SettingsConst.CryptoKeys.USERNAME
              forService:SettingsConst.TXCRYPTOSVC_GENERIC];
}

-(void)setUserId:(NSNumber*)userId {
    [FDKeychain saveItem:userId forKey:SettingsConst.CryptoKeys.USERID
              forService:SettingsConst.TXCRYPTOSVC_GENERIC];
}

-(void)setPassword:(NSString*)pwd {
    [FDKeychain saveItem:pwd forKey:SettingsConst.CryptoKeys.PASSWORD
              forService:SettingsConst.TXCRYPTOSVC_GENERIC];
}

-(void) setGoogleUserId : (NSString *)userId {
    [FDKeychain saveItem:userId forKey:SettingsConst.SignInProviders.Google.USERID
              forService:SettingsConst.TXCRYPTOSVC_GENERIC];
}

-(NSString*)getGoogleUserId {
    return [FDKeychain itemForKey:SettingsConst.SignInProviders.Google.USERID
                       forService:SettingsConst.TXCRYPTOSVC_GENERIC];
}

-(void) setFBUserId : (NSString *)userId {
    [FDKeychain saveItem:userId forKey:SettingsConst.SignInProviders.Facebook.USERID
              forService:SettingsConst.TXCRYPTOSVC_GENERIC];
}

-(NSString*)getFBUserId {
    return [FDKeychain itemForKey:SettingsConst.SignInProviders.Facebook.USERID
                       forService:SettingsConst.TXCRYPTOSVC_GENERIC];
}

-(void)setUserToken:(NSString *)token {
    [FDKeychain saveItem:token forKey:SettingsConst.CryptoKeys.USERTOKEN
              forService:SettingsConst.TXCRYPTOSVC_GENERIC];
}

-(void)removeUserToken {
    [FDKeychain deleteItemForKey:SettingsConst.CryptoKeys.USERTOKEN
                forService:SettingsConst.TXCRYPTOSVC_GENERIC];
}

-(NSString *)getUserToken {
    return [FDKeychain itemForKey:SettingsConst.CryptoKeys.USERTOKEN
                       forService:SettingsConst.TXCRYPTOSVC_GENERIC];
}

-(void) setNotificationsToken : (NSString *)token {
    [FDKeychain saveItem:token forKey:SettingsConst.CryptoKeys.NOTIFICATIONS_TOKEN
              forService:SettingsConst.TXCRYPTOSVC_GENERIC];
}

-(NSString*)getNotificationsToken {
    return [FDKeychain itemForKey:SettingsConst.CryptoKeys.NOTIFICATIONS_TOKEN
                       forService:SettingsConst.TXCRYPTOSVC_GENERIC];
}

-(int) getMaxHTTPConnectionsNumber {
    return [ [self getProperty:SettingsConst.Property.MAXHTTPCONNECTIONS] intValue];
}

-(void)onRequestCompleted:(id)object {
    
}

-(void)onFail:(id)object error:(TXError *)error {
   
}

@end
