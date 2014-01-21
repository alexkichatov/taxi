//
//  utils.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/20/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "utils.h"
#import "StrConsts.h"
#import "NSString+TXNSString.h"
#import <CommonCrypto/CommonDigest.h>

//load Taxi resource bundle if not already loaded and retreive localized string by key
NSString* TXLocalizedString(NSString* key, NSString* comment) {
    static NSBundle* bundle = nil;
    
    if ( bundle == nil ) {
        NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:Files.BUNDLE_PATH];
        bundle = [NSBundle bundleWithPath:path];
        DLogI(@"Current locale: %@, AMDCom Bundle localizations: %@", [[NSLocale currentLocale] localeIdentifier], [bundle localizations]);
    }
    
    return [bundle localizedStringForKey:key value:key table:@"InfoPlist"];
}


NSString* base64String(NSString* str) {
    NSData *theData = [str dataUsingEncoding: NSASCIIStringEncoding];
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

NSString* attachmentNameFromDao(NSString* type, NSString* amdcRowId, NSString* originalFileName) {

    if ([originalFileName rangeOfString:@"."].location == NSNotFound) {
        DLogE(@"Invalid file name, %@ does not contain extension.", originalFileName);
        return nil;
    }
    
    return [NSString stringWithFormat:@"%@_%@.%@", type, amdcRowId, [originalFileName substringUpToLastOccurance:'.']];
    
}

BOOL containsRegExprStr(NSString * regex, NSString * targetStr) {
    NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", regex];
    if ([regextest evaluateWithObject:targetStr] == YES) {
        /* when matchess template */
        return YES;
    }
    else {
        /* when not matches */
        return NO;
    }
}

NSString* replaceRegexpStr(NSString *regexpStr, NSString *replaceWithStr, NSString *targetStr) {
    NSError *error = NULL;
    NSRegularExpression * regexStr = [NSRegularExpression regularExpressionWithPattern:regexpStr options:NSRegularExpressionCaseInsensitive error:&error] ;
    NSString * replacedStr = [regexStr stringByReplacingMatchesInString:targetStr options:0 range:NSMakeRange(0, [targetStr length]) withTemplate:replaceWithStr];
    return replacedStr;
}

/*********************** Json Utils ************************/

NSString* getJSONStr (id jsonObj) {
    
#ifndef DEBUG
    NSJSONWritingOptions options = 0;
#else
    NSJSONWritingOptions options = NSJSONWritingPrettyPrinted;
#endif
    
    if ( jsonObj != nil ) {
        
        if ( ![jsonObj isKindOfClass:[NSString class]] ) {
            NSError *error_;
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonObj options:options error:&error_];
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        return jsonObj;
    }
    
    return @"null";
}

inline id getJSONObj (NSString* jsonStr) {
    NSError *error_;
    return [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error_] ;
}

inline id getJSONObjFromData (NSData* jsonData) {
    NSError *error_;
    return [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error_] ;
}

NSString* id2JSONStr(id newValue) {
    NSString* valStr;
    //add quotes around all values except numbers
    if(newValue == nil || newValue == [NSNull null]) {
        valStr = @"null";
    } else if (![newValue isKindOfClass:[NSNumber class]] )
        valStr = [NSString stringWithFormat:@"\"%@\"", newValue];
    else
        valStr = [NSString stringWithFormat:@"%@", newValue];
    return valStr;
}

/*********************** Json Utils ************************/


/*********************** Date utils ************************/
inline NSString* date2MilliSecStr(NSDate* date) {
    return [NSString stringWithFormat:@"%llu", date2MilliSecs(date)];
}

inline unsigned long long date2MilliSecs(NSDate* date) {
    return (unsigned long long)[date timeIntervalSince1970]*MILLISECONDSINSECOND;
}

inline NSString* quoteString(NSString* src) {
    if ( src != nil )
        return [NSString stringWithFormat:@"\"%@\"", src];
    else
        return @"\"\"";
}

/*********************** Date utils ************************/

/*********************** SHA ************************/

NSString* getSHA256(NSString *str) {
    
    NSData *dataIn = [str dataUsingEncoding:NSASCIIStringEncoding];
    NSMutableData *dataOut = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(dataIn.bytes, dataIn.length,  dataOut.mutableBytes);
    return [[NSString alloc] initWithData:dataOut encoding:NSASCIIStringEncoding];
    
}

NSString* getSHA512(NSString *str) {
    
    NSData *dataIn = [str dataUsingEncoding:NSASCIIStringEncoding];
    NSMutableData *dataOut = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(dataIn.bytes, dataIn.length,  dataOut.mutableBytes);
    return [[NSString alloc] initWithData:dataOut encoding:NSASCIIStringEncoding];
    
}

/*********************** SHA ************************/