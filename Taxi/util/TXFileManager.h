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

/*!@function installPackageFileFromBundle
 * Copies the file from specified bundle to documents directory.
 * If the file with the same name already exists at path, it will be removed.
 * If directory path is specified, checks if directory structure exists and creates if any of them are missing
 
 @param bundleFile - If bundle is not specified (nil), copies the file from the default amdcomres.bundle
 @param path - If the file needs to be created in root of the documents directory, then path should contain only file name, either '/path1/path2/fileName.*'.
 @return BOOL.
 */
-(BOOL) installPackageFileFromBundle: (NSString *)bundleFile andDestination:(NSString *)path andError: (TXError **) error;

-(BOOL) deleteLocalFile : (NSString *) path andError: (TXError **) error;

-(BOOL) resetUserData: (TXError **) error;

-(BOOL) mkDir : (NSString *) dirPath andError: (TXError **) error;

-(BOOL) readLocalFile : (NSString *) fileName andData : (NSData **) data andError: (TXError **) error ;

-(unsigned long long)freeDiskspaceInBytes;

-(unsigned long long) getFileSize:(NSString*) filePath andError: (TXError **) error;

-(BOOL) writeToLocalFile : (NSString *) fileName andData : (NSData *) data overWrite : (BOOL) overWrite andError: (TXError **) error;

@end
