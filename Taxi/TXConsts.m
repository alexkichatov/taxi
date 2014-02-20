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

const struct API_JSON API_JSON = {
    
    .Keys = {
        .OPER     = @"operation",
        .ATTR     = @"attr",
        .DATA     = @"data",
        .SUCCESS  = @"success"
    },
    
    .Authenticate = {
        .USERNAME = @"username",
        .PASSWORD = @"password"
    }
    
};