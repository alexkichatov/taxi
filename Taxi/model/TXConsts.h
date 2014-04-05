//
//  TXConsts.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/29/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

extern const struct HTTP_API {
    __unsafe_unretained NSString* REGISTER;
    __unsafe_unretained NSString* AUTHENTICATE;
} HTTP_API;

extern const struct KEYS {
    
    struct {
        __unsafe_unretained NSString* CLIENTID;
        
    } Google;
    
} KEYS;


extern const struct API_JSON {
    
    struct {
        __unsafe_unretained NSString* OPER;
        __unsafe_unretained NSString* ATTR;
        __unsafe_unretained NSString* DATA;
        __unsafe_unretained NSString* SUCCESS;
        __unsafe_unretained NSString* MESSAGE;
        
    } Keys;
    
    struct {
        __unsafe_unretained NSString* USERNAME;
        __unsafe_unretained NSString* PASSWORD;
        __unsafe_unretained NSString* PROVIDERUSERID;
        __unsafe_unretained NSString* PROVIDERID;
        __unsafe_unretained NSString* LOGINWITHPROVIDER;
        
    } Authenticate;
    
} API_JSON;

extern const struct LEFT_MENU {
    
    struct {

        __unsafe_unretained NSString* HOME;
        __unsafe_unretained NSString* PROFILE;
        __unsafe_unretained NSString* SETTINGS;
        __unsafe_unretained NSString* SIGNOUT;
        
    } Names;
    
    struct {
        
        __unsafe_unretained NSString* HOME;
        __unsafe_unretained NSString* PROFILE;
        __unsafe_unretained NSString* SETTINGS;
        __unsafe_unretained NSString* SIGNOUT;
        
        
    } Images;
    
    struct {
        
        __unsafe_unretained NSString* HOME;
        __unsafe_unretained NSString* PROFILE;
        __unsafe_unretained NSString* SETTINGS;
        __unsafe_unretained NSString* SIGNOUT;
        
    } Controllers;
    
} LEFT_MENU;

extern const struct PROVIDERS {
    
    __unsafe_unretained NSString* FACEBOOK;
    __unsafe_unretained NSString* GOOGLE;
    
} PROVIDERS;