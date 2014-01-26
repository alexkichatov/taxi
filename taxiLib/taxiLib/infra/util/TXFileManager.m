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

-(NSString *) getFullFilePathFromDocumentsDir : (NSString *)relativePath {
    return [self->documentsDirectory stringByAppendingPathComponent:relativePath];
}

@end
