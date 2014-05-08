//
//  TXFileManager.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/20/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXFileManager.h"
#import "StrConsts.h"
#import "Macro.h"
#import "NSString+TXNSString.h"

@interface TXFileManager() {
    
    NSFileManager *fileManager;
    NSString *documentsDirectory;
    NSString* bundlePath;
    
}

@end

@implementation TXFileManager

/** Creates the single instance within the application
 
 @return AMDCFileManager
 */
+(TXFileManager *) instance {
    static dispatch_once_t pred;
    static TXFileManager* _instance;
    dispatch_once(&pred, ^{ _instance = [[self alloc] init]; });
    return _instance;
}

-(id)init {
    
    self = [super init];
    
    if(self) {
        self->fileManager = [NSFileManager defaultManager];
        self->documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSLog(@"%@", self->documentsDirectory);
        self->bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:Files.BUNDLE_PATH];
        DLogI(@"Documents directory path = %@", self->documentsDirectory);
        DLogI(@"Bundle path = %@", self->bundlePath);
    }
    
    return self;
}

-(BOOL) localFileExists : (NSString*) filePath {
    
    if([filePath length]!=0) {
        
        BOOL isDir;
        NSString *relativePath = [self getFullFilePathFromDocumentsDir:filePath];
        BOOL exists = [self->fileManager fileExistsAtPath:relativePath isDirectory:&isDir];
        if (exists && !isDir){
            return YES;
        } else {
            DLogI(@"File does not exist : %@", filePath);
        }
        
    }
    
    return NO;
}

-(BOOL) packageFileExists : (NSString*) fileName {
    
    if([fileName length]>0) {
        
        return [self->fileManager fileExistsAtPath:[self->bundlePath stringByAppendingPathComponent:fileName]];
        
    }
    
    NSLog(@"Package file %@ does not exists at path %@ in application bundle", fileName, self->bundlePath);
    return NO;
}

-(BOOL) resetUserData: (TXError **) error {
    
    NSArray *files = [self->fileManager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    BOOL result = YES;
    
    for (int i = 0; i < files.count; i++) {
        NSError *err;
        BOOL ok = [self->fileManager removeItemAtPath:[self getFullFilePathFromDocumentsDir:files[i]] error:&err];
        
        if( ok==NO ) {
            
            result = ok;
            NSString * msg  = err!=nil ? [err description] : [NSString stringWithFormat:@"Failed to remove file %@ !", [self getFullFilePathFromDocumentsDir:files[i]]];
            
            *error = [TXError error:TX_ERR_FILE_DELETE_FAILED
                                 message:msg
                             description:[NSString stringWithFormat:@"AMDCFileManager, resetUserData, self->fileManager removeItemAtPath: %@", [self getFullFilePathFromDocumentsDir:files[i]]]];

            DLogE(@"Error removing file %@", files[i]);
        }
    }
    
    return result;
}

-(BOOL) deleteLocalFile : (NSString *) path andError: (TXError **) error {

    NSError *err;
    if([path length] > 0) {
        
        if([fileManager removeItemAtPath:[self getFullFilePathFromDocumentsDir:path] error:&err] == YES) {
            DLogI(@"Deleted local file - %@", path);
            return YES;
            
        } else {
            
            NSString * msg  = err!=nil ? [err description] : [NSString stringWithFormat:@"Failed to remove file %@ !", [self getFullFilePathFromDocumentsDir:path]];;
            
            *error = [TXError error:TX_ERR_FILE_DELETE_FAILED
                                 message:msg
                             description:[NSString stringWithFormat:@"TXFileManager, deleteLocalFile, self->fileManager removeItemAtPath: %@", [self getFullFilePathFromDocumentsDir:path]]];

            DLogE(@"Delete file %@ error: %@ ", path, [err description]);
        }
        
    }
    
    DLogE(@"Incorrect parameter was passed, path is null");
    return NO;
}

-(BOOL) installPackageFileFromBundle: (NSString *)bundleFile andDestination:(NSString *)path andError: (TXError **) error {
    
    if([bundleFile length] > 0 && [path length] > 0) {
        
        /*
         * First, we should remove the file
         */
        if([self localFileExists:path]) {
            
            if([self deleteLocalFile:path andError:error] == NO) {
                DLogE(@"File exists, but it failed to remove, check if it is being used by another process, file path: %@", path);
            }
        }
        
        /*
         * Here we need to create directories with subdirectories
         */
        NSString *dirPath;
        NSError *err;
        if([path indexOf:'/'] == NSNotFound) {
            dirPath = [self getFullFilePathFromDocumentsDir:path];
        } else {
            
            dirPath = [self getFullFilePathFromDocumentsDir:[path substringFromRightFromCharacter:'/']];
            
            if([self->fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&err] == NO) {
                *error = [TXError error:TX_ERR_DIR_CREATE_FAILED message:[err description] description:[NSString stringWithFormat:@"TXFileManager, installPackageFromBundle, createDirectoryAtPath: %@", dirPath]];
                DLogI(LocalizedStr(@"File.Err.pkgWasNotInstalled"), [err description]);
                return NO;
            }
            
        }
        
        /*
         * Copying file to destination path
         */
        if([self->fileManager copyItemAtPath:[bundlePath stringByAppendingPathComponent:bundleFile] toPath:[self getFullFilePathFromDocumentsDir:path] error:&err] == YES) {
            DLogI(@"Package installed successfully, bundle file path : %@, destination path : %@", bundleFile, path);
            return YES;
            
        } else {
            
            *error = [TXError error:TX_ERR_FILE_COPY_FAILED message:[err description] description:[NSString stringWithFormat:@"TXFileManager, installPackageFromBundle, copyItemAtPath: %@, bundleFile: %@", path, bundleFile]];
            DLogI(LocalizedStr(@"File.Err.pkgWasNotInstalled"), [err description]);
            return NO;
            
        }
        
    } else {
        DLogI(@"Incorrect input parameters, bundleFile : %@, destination path : %@", bundleFile, path);
    }
    
    return NO;
}

-(BOOL) readLocalFile : (NSString *) fileName andData : (NSData **) data andError: (TXError **) error {

    if([fileName length] > 0) {
        
        if([self localFileExists:fileName] == YES) {
            
            *data = [self->fileManager contentsAtPath:[self getFullFilePathFromDocumentsDir:fileName]];
            return YES;
            
        } else {
            
            *error = [TXError error:TX_ERR_FILE_NOT_FOUND
                                 message:[NSString stringWithFormat:@"File does not exits at path %@ !", [self getFullFilePathFromDocumentsDir:fileName]]
                             description:[NSString stringWithFormat:@"AMDCFileManager, readLocalFile, self->fileManager contentsAtPath: %@", [self getFullFilePathFromDocumentsDir:fileName]]];
            
        }
        
    }
    
    DLogI(@"Incorrect input parameter, fileName is null");
    return NO;
    
}

-(BOOL) writeToLocalFile : (NSString *) fileName andData : (NSData *) data overWrite : (BOOL) overWrite andError: (TXError **) error {

    if([fileName length] > 0 && data!=nil) {
        
        int bytesLength = [data length];
        if(bytesLength>=[self freeDiskspaceInBytes]) {
            
            *error = [TXError error:TX_ERR_NO_FREE_SPACE
                                    message:@"No free sapce"
                                    description:[NSString stringWithFormat:@"AMDCFileManager, writeToLocalFile, self freeDiskspaceInBytes: %i", bytesLength]];
            return NO;
        }
        
        if(overWrite==NO) {
            
            NSFileHandle *handle = [NSFileHandle fileHandleForUpdatingAtPath:[self getFullFilePathFromDocumentsDir:fileName]];
            [handle seekToEndOfFile];
            [handle writeData:data];
            [handle closeFile];
            return YES;
            
        } else {
            
            if([self localFileExists:fileName]==YES) {
                
                if([self deleteLocalFile:fileName andError:error] == YES) {
                    [fileManager createFileAtPath:[self getFullFilePathFromDocumentsDir:fileName] contents:data attributes:nil];
                } else {
                    DLogE(@"Failed to remove file: %@", fileName);
                    return NO;
                }
                
            } else {
                
                DLogI(@"Creating local file -> %@", fileName);
                
                /*
                 * Here we need to create directories with subdirectories
                 */
                NSString *dirPath;
                NSError *err;
                if([fileName indexOf:'/'] == NSNotFound) {
                    dirPath = [self getFullFilePathFromDocumentsDir:fileName];
                } else {
                    
                    dirPath = [self getFullFilePathFromDocumentsDir:[fileName substringFromRightFromCharacter:'/']];
                    
                    if([self->fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&err] == NO) {
                        
                        NSString * msg  = err!=nil ? [err description] : [NSString stringWithFormat:@"Failed to create directory %@ !", dirPath];
                        
                        *error = [TXError error:TX_ERR_DIR_CREATE_FAILED
                                          message:msg
                                          description:[NSString stringWithFormat:@"AMDCFileManager, writeToLocalFile, self->fileManager createDirectoryAtPath: %@", dirPath]];
                        DLogI(LocalizedStr(@"File.Err.pkgWasNotInstalled"), [err description]);
                        return NO;
                    }
                    
                }
                
                /* Creating file to destination path */
                dirPath = [self getFullFilePathFromDocumentsDir:fileName];
                BOOL success = [self->fileManager createFileAtPath:dirPath contents:data attributes:nil];
                if ( success == NO ) {
                    DLogE(@"Couldn't create file - %@/%@", dirPath, fileName);
                }
                return success;
            }
            
            return YES;
        }
    }
    
    DLogI(@"Incorrect input parameters, fileName: %@, data : %@", fileName, data);
    return NO;
    
}

-(BOOL) mkDir : (NSString *) dirPath andError: (TXError **) error {
    
    if([dirPath length] != 0 && ![dirPath isEqualToString:@"/"]) {
        
        NSError *err;
        if([self->fileManager createDirectoryAtPath:[self getFullFilePathFromDocumentsDir:dirPath] withIntermediateDirectories:YES attributes:nil error:&err] != NO) {
            
            return YES;
            
        } else {
            
            NSString * msg  = err!=nil ? [err description] : [NSString stringWithFormat:@"Failed to create directory %@ !", dirPath];
            
            *error = [TXError error:TX_ERR_DIR_CREATE_FAILED
                                 message:msg
                             description:[NSString stringWithFormat:@"AMDCFileManager, mkDir, self->fileManager createDirectoryAtPath: %@", dirPath]];
        }
        
    }
    
    DLogI(@"Incorrect input parameters, dirPath should not be empty");
    return NO;
    
}

-(unsigned long long)freeDiskspaceInBytes
{
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [self->fileManager attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary!=nil) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        DLogI(@"Current total space - %llu MB, Free space - %llu MB", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        DLogE(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]);
    }
    
    return totalFreeSpace;
}

-(unsigned long long) getFileSize:(NSString*) filePath andError: (TXError **) error {

    NSError* err = nil;
    NSDictionary *fileAttributes = nil;
    unsigned long long result = 0;
    
    if([filePath length] > 0) {
        
        fileAttributes = [self->fileManager attributesOfItemAtPath:[self getFullFilePathFromDocumentsDir:filePath] error:&err];
        
        if ( err != nil ) {
            
            *error = [TXError error:TX_ERR_FILE_ATTR_READ_FAILED
                              message:[err description]
                              description:[NSString stringWithFormat:@"AMDCFileManager, getFileSize, self->fileManager attributesOfItemAtPath: %@", [self getFullFilePathFromDocumentsDir:filePath]]];
            
        } else {
            result = [[fileAttributes objectForKey:NSFileSize] longLongValue];
        }
        
    }
    
    return result;
}

-(NSString *) getFullFilePathFromDocumentsDir : (NSString *)relativePath {
    return [self->documentsDirectory stringByAppendingPathComponent:relativePath];
}

@end
