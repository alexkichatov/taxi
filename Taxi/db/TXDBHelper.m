//
//  TXDBHelper.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/20/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXDBHelper.h"
#import "sqlite3.h"
#import "TXFileManager.h"

NSString* const DB_PATH = @"/db";
NSString* const DB_NAME = @"taxi.sqlite";

@interface TXDBHelper() {
    BOOL          isInitialized;
    TXFileManager *fileMgr;
    sqlite3       *db;
    NSMutableDictionary *columnNameMap;
    sqlite3_stmt *statement;
}

@end

@implementation TXDBHelper

/** Creates the single instance within the application
 
 @return TXDBHelper
 */
+(TXDBHelper *) mainDBInstance {
    static dispatch_once_t pred;
    static TXDBHelper* _instance;
    dispatch_once(&pred, ^{ _instance = [[self alloc] init]; });
    return _instance;
}

-(id)init {
    
    if(self = [super init]) {
        self->fileMgr       = [TXFileManager instance];
        self->isInitialized = NO;
        self->db            = [self initialize:DB_NAME];
    }
    
    return self;
}

+(TXDBHelper *) mainDB {
    return [TXDBHelper mainDBInstance];
}

-(sqlite3 *) initialize : (NSString *) databaseName {
    
    sqlite3         *db_            = nil;
    NSString        *dbRelativePath = [DB_PATH stringByAppendingPathComponent:databaseName];
    NSString        *dbFullPath     = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]  stringByAppendingPathComponent:dbRelativePath];
    TXFileManager   *fileManager    = [TXFileManager instance];
    
    TXError *error;
    if([fileManager localFileExists:dbRelativePath] == YES || [fileManager installPackageFileFromBundle:databaseName andDestination:dbRelativePath andError:&error]==YES) {
        
        if(sqlite3_open([dbFullPath UTF8String], &db_) == SQLITE_OK) {
            self->isInitialized = YES;
            return db_;
        }
        
    }
    
    return nil;
}

-(NSArray *) executeQuery : (NSString *) queryStr withParameterDictionary:(NSDictionary *)arguments {
 
    NSMutableArray *result = [NSMutableArray new];
    
    if (sqlite3_prepare_v2(self->db, [queryStr UTF8String], -1, &self->statement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(self->statement) == SQLITE_ROW) {
            [result addObject:[self resultDict]];
        }
    }
    
    sqlite3_finalize(self->statement);
    
    return result;
}

- (int)columnCount {
    return sqlite3_column_count(self->statement);
}

- (void)setupColumnNames {
    

    self->columnNameMap = [NSMutableDictionary dictionary];
    
    int columnCount = sqlite3_column_count(self->statement);
    
    int columnIdx = 0;
    for (columnIdx = 0; columnIdx < columnCount; columnIdx++) {
        [self->columnNameMap setObject:[NSNumber numberWithInt:columnIdx]
                                  forKey:[[NSString stringWithUTF8String:sqlite3_column_name(self->statement, columnIdx)] lowercaseString]];
    }
}

- (NSDictionary*)resultDict {
    
    int num_cols = sqlite3_data_count(self->statement);
    
    if (num_cols > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:num_cols];

        [self setupColumnNames];
        
        NSEnumerator *columnNames = [self->columnNameMap keyEnumerator];
        NSString *columnName = nil;
        while ((columnName = [columnNames nextObject])) {
            id objectValue = [self objectForColumnName:columnName];
            [dict setObject:objectValue forKey:columnName];
        }
        
        return dict;
    }
    else {
        NSLog(@"Warning: There seem to be no columns in this set.");
    }
    
    return nil;
}

- (int)columnIndexForName:(NSString*)columnName {
    
    [self setupColumnNames];
    
    columnName = [columnName lowercaseString];
    
    NSNumber *n = [self->columnNameMap objectForKey:columnName];
    
    if (n) {
        return [n intValue];
    }
    
    NSLog(@"Warning: I could not find the column named '%@'.", columnName);
    
    return -1;
}



- (int)intForColumn:(NSString*)columnName {
    return [self intForColumnIndex:[self columnIndexForName:columnName]];
}

- (int)intForColumnIndex:(int)columnIdx {
    return sqlite3_column_int(self->statement, columnIdx);
}

- (long)longForColumn:(NSString*)columnName {
    return [self longForColumnIndex:[self columnIndexForName:columnName]];
}

- (long)longForColumnIndex:(int)columnIdx {
    return (long)sqlite3_column_int64(self->statement, columnIdx);
}

- (long long int)longLongIntForColumn:(NSString*)columnName {
    return [self longLongIntForColumnIndex:[self columnIndexForName:columnName]];
}

- (long long int)longLongIntForColumnIndex:(int)columnIdx {
    return sqlite3_column_int64(self->statement, columnIdx);
}

- (unsigned long long int)unsignedLongLongIntForColumn:(NSString*)columnName {
    return [self unsignedLongLongIntForColumnIndex:[self columnIndexForName:columnName]];
}

- (unsigned long long int)unsignedLongLongIntForColumnIndex:(int)columnIdx {
    return (unsigned long long int)[self longLongIntForColumnIndex:columnIdx];
}

- (BOOL)boolForColumn:(NSString*)columnName {
    return [self boolForColumnIndex:[self columnIndexForName:columnName]];
}

- (BOOL)boolForColumnIndex:(int)columnIdx {
    return ([self intForColumnIndex:columnIdx] != 0);
}

- (double)doubleForColumn:(NSString*)columnName {
    return [self doubleForColumnIndex:[self columnIndexForName:columnName]];
}

- (double)doubleForColumnIndex:(int)columnIdx {
    return sqlite3_column_double(self->statement, columnIdx);
}

- (NSString*)stringForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type(self->statement, columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
        return nil;
    }
    
    const char *c = (const char *)sqlite3_column_text(self->statement, columnIdx);
    
    if (!c) {
        // null row.
        return nil;
    }
    
    return [NSString stringWithUTF8String:c];
}

- (NSString*)stringForColumn:(NSString*)columnName {
    return [self stringForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSDate*)dateForColumn:(NSString*)columnName {
    return [self dateForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSData*)dataForColumn:(NSString*)columnName {
    return [self dataForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSData*)dataForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type(self->statement, columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
        return nil;
    }
    
    int dataSize = sqlite3_column_bytes(self->statement, columnIdx);
    
    NSMutableData *data = [NSMutableData dataWithLength:dataSize];
    
    memcpy([data mutableBytes], sqlite3_column_blob(self->statement, columnIdx), dataSize);
    
    return data;
}

- (NSDate*)dateForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type(self->statement, columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
        return nil;
    }
    
    return [NSDate dateWithTimeIntervalSince1970:[self doubleForColumnIndex:columnIdx]];
}

- (id)objectForColumnIndex:(int)columnIdx {
    int columnType = sqlite3_column_type(self->statement, columnIdx);
    
    id returnValue = nil;
    
    if (columnType == SQLITE_INTEGER) {
        returnValue = [NSNumber numberWithLongLong:[self longLongIntForColumnIndex:columnIdx]];
    }
    else if (columnType == SQLITE_FLOAT) {
        returnValue = [NSNumber numberWithDouble:[self doubleForColumnIndex:columnIdx]];
    }
    else if (columnType == SQLITE_BLOB) {
        returnValue = [self dataForColumnIndex:columnIdx];
    }
    else {
        //default to a string for everything else
        returnValue = [self stringForColumnIndex:columnIdx];
    }
    
    if (returnValue == nil) {
        returnValue = [NSNull null];
    }
    
    return returnValue;
}

- (id)objectForColumnName:(NSString*)columnName{
    return [self objectForColumnIndex:[self columnIndexForName:columnName]];
}

// returns autoreleased NSString containing the name of the column in the result set
- (NSString*)columnNameForIndex:(int)columnIdx {
    return [NSString stringWithUTF8String: sqlite3_column_name(self->statement, columnIdx)];
}

-(BOOL) executeUpdate : (NSString *) sqlStr withArgumentsInArray:(NSArray *)arguments {
    return NO;
}

-(int) close {
    return sqlite3_close(self->db);
}

@end
