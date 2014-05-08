//
//  TXSqlGenerator.h
//  Taxi
//
//  Created by Irakli Vashakidze on 2/11/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXSqlGenerator : NSObject

/**
 Generates short insert statement using format:
 INSERT INTO TABLENAME VALUES (?,?,...)
 */
+(NSString*) getInsertShort:(NSString*)table paramCount:(int)paramCount;
+(NSString*) getInsert:(NSString*)table fieldNames:(NSArray*)fieldNames;

+(NSString*) getUpdateStatement:(NSString*)table fieldNames:(NSArray*)fieldNames searchColNames:(NSArray*)searchColNames;
+(NSString*) getUpdateStatement:(NSString*)table fieldNames:(NSArray*)fieldNames searchSpec:(NSString*)searchSpec;

+(NSString*) getUpdateStatementByKey:(NSString*)table fieldNames:(NSArray*)fieldNames keyCol:(NSString*)keyCol;

+(NSString*) getDeleteStatement:(NSString*)table searchColNames:(NSArray*)searchColNames;
+(NSString*) getDeleteStatement:(NSString*)table searchSpec:(NSString*)searchSpec;

+(NSString*) getQueryStatement:(NSString*)table joinDefs:(NSArray*)joins
                    fieldNames:(NSArray*)fieldNames searchColNames:(NSArray*)searchColNames
                      sortCols:(NSArray*)sortCols groupBy:(NSArray*)groupBy
                         limit:(int)limit offset:(int)offset;

+(NSString*) getQueryStatement:(NSString*)table joinDefs:(NSArray*)joins
                    fieldNames:(NSArray*)fieldNames searchSpec:(NSString*)searchSpec
                      sortCols:(NSArray*)sortCols groupBy:(NSArray*)groupBy
                         limit:(int)limit offset:(int)offset;

+(NSString*) getRowExistsStatement:(NSString*)table searchSpec:(NSString*)searchSpec;

@end
