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

extern const struct API_JSON {
    
    struct {
        __unsafe_unretained NSString* OPER;
        __unsafe_unretained NSString* ATTR;
        __unsafe_unretained NSString* DATA;
        __unsafe_unretained NSString* SUCCESS;
        
    } Keys;
    
    struct {
        __unsafe_unretained NSString* USERNAME;
        __unsafe_unretained NSString* PASSWORD;
        
    } Authenticate;
    
    
} API_JSON;
