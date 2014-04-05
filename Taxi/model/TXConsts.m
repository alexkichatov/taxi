//
//  TXConsts.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/29/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXConsts.h"

const struct HTTP_API HTTP_API = {
        .REGISTER = @"register",
        .AUTHENTICATE = @"login"
};

const struct KEYS KEYS = {
    
    .Google = {
     
        .CLIENTID = @"177846177917-1r8cvuslmtv3lfj2k1np42k0sk402n56.apps.googleusercontent.com",
        
    }
    
};

const struct API_JSON API_JSON = {
    
    .Keys = {
        .OPER     = @"operation",
        .ATTR     = @"attr",
        .DATA     = @"data",
        .SUCCESS  = @"success",
        .MESSAGE  = @"message"
    },
    
    .Authenticate = {
        .USERNAME = @"username",
        .PASSWORD = @"password",
        .PROVIDERUSERID = @"providerUserId",
        .PROVIDERID = @"providerId",
        .LOGINWITHPROVIDER = @"loginWithProvider"
    }
    
};

const struct LEFT_MENU LEFT_MENU = {
    
    .Names = {
    
        .HOME = @"Home",
        .PROFILE = @"Profile",
        .SETTINGS = @"Settings",
        .SIGNOUT = @"Sign out"
    },
    
    .Images = {
        
        .HOME = @"button-home",
        .PROFILE = @"button-profile",
        .SETTINGS = @"button-settings",
        .SIGNOUT = @"button-signout"
        
    },
   
    .Controllers = {
        
        .HOME = @"TXMainVC",
        .PROFILE = @"TXMainVC",
        .SETTINGS = @"TXMainVC",
        .SIGNOUT = @"TXMainVC"
        
    }
    
};

const struct PROVIDERS PROVIDERS = {
    
    .FACEBOOK = @"http://www.facebook.com",
    .GOOGLE   = @"http://www.google.com"
    
};