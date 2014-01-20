//
//  Macros.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/20/14.
//  Copyright (c) 2014 Taxi. All rights reserved.
//

#ifndef __MACROS__
#define __MACROS__

#define MILLISECONDSINSECOND    1000

#define AMDCLogLevelDisabled    0
#define AMDCLogLevelError       1
#define AMDCLogLevelInfo        2
#define AMDCLogLevelVerbose     3

#define TEMP00 AMDCLogLevelDisabled;

#define SYSTEM_VERSION_GREATER_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

//define logvelev as 0 (errors only) if it wasn't defined in the preprocessor settings
#ifndef LOG_LEVEL
    #define LOG_LEVEL 1
#endif

//Logs formatted string without checkign log level in debug mode.
#ifdef DEBUG
#define DLog(FORMAT, ...) fprintf(stderr,"%s, line - %d, %s\n", __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#define CRASHWITHMSG(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]

#else
    #define DLog(...);
    #define CRASHWITHMSG(FORMAT, ...) fprintf(stderr,"%s, line - %d, %s\n", __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#endif

//Errors Logs formatted string if log level 1 in debug mode.
#if defined DEBUG && LOG_LEVEL > AMDCLogLevelDisabled
#define DLogE(FORMAT, ...) fprintf(stderr,"%s, line - %d, %s\n", __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DLogE(...);
#endif


//Info Logs formatted string if log level 1 in debug mode.
#if defined DEBUG && LOG_LEVEL > AMDCLogLevelError
#define DLogI(FORMAT, ...) fprintf(stderr,"%s, line - %d, %s\n", __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DLogI(...);
#endif


//Verbose mode, Logs formatted string if log level 2 in debug mode.
#if defined DEBUG && LOG_LEVEL > AMDCLogLevelInfo
#define DLogV(FORMAT, ...) fprintf(stderr,"%s, line - %d, %s\n", __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DLogV(...) ;
#endif

//logs in release mode as well, use ONLY for cases when critical error occures and logdb is not available
//everythign else goes into logdb tables
#define RLog(FORMAT, ...) fprintf(stderr,"%s, line - %d, %s\n", __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);


#define LocalizedStr(lsKey) AMDCLocalizedString(lsKey, nil)


#define BUNDLE_VERSION  [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]
#define APPDELEGATE ([UIApplication sharedApplication].delegate)





#endif //__MACROA__"