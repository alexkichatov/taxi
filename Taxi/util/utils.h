//
//  utils.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/20/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#ifndef __AMDCUTILS__
#define __AMDCUTILS__

#import <Foundation/Foundation.h>
#import "Macro.h"

NSString* TXLocalizedString(NSString* key, NSString* comment);
NSString* base64String(NSString* str);
NSString* attachmentNameFromDao(NSString* type, NSString* amdcRowId, NSString* originalFileName);

NSString* getJSONStr (id jsonObj);
id getJSONObj (NSString* jsonStr);
id getJSONObjFromData (NSData* jsonData);

NSString* date2MilliSecStr(NSDate* date);
unsigned long long date2MilliSecs(NSDate* date);

NSString* quoteString(NSString* src);
NSString* id2JSONStr(id newValue);

/**
 matches-contains or not target str a regular expression pattern
 
 @param regex - what to search in regular expression pattern
 @param targetStr - where to search
 @result - bool
 */
BOOL containsRegExprStr(NSString * regex, NSString * targetStr);
/**
 replaces into targetStr a regular expression pattern with replaceWithStr
 
 @param regexpStr - what to search in regular expression pattern
 @parAM replaceWithStr  - replacement string
 @param targetStr - where to search
 @result - replaced NSString
 */
NSString* replaceRegexpStr(NSString *regexpStr, NSString *replaceWithStr, NSString *targetStr);

NSData* getSHA256(NSString *str);
NSData* getSHA512(NSString *str);
NSString* getHexString(NSData * data);
NSString* getIPv4Address();

#endif //__AMDCUTILS__