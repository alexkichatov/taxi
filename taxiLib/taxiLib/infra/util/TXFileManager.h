//
//  TXFileManager.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/20/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXError.h"

@interface TXFileManager : NSObject

/*!@function instance
 * Creates the single instance within the application
 @return TXFileManager
 */
+(TXFileManager *) instance;

/*!@function localFileExists
 * Returns YES, if file exists in documents directory, either returns NO
 @param filePath
 @return BOOL.
 */
-(BOOL) localFileExists : (NSString*) filePath;

/*!@function packageFileExists
 * Returns YES, if the file exists taxi.bundle, either returns NO
 @param fileName
 @param bundlePath
 @return BOOL.
 */
-(BOOL) packageFileExists : (NSString*) filePath;

@end
