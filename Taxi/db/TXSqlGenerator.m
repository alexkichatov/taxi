//
//  TXSqlGenerator.m
//  Taxi
//
//  Created by Irakli Vashakidze on 2/11/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXSqlGenerator.h"
#import "utils.h"
#import "DBTypes.h"
#import "StrConsts.h"

@implementation TXSqlGenerator

/**
 Generates insert statement using the following format:
 INSERT INTO table VALUES (?,?...)
 @param table table name
 @param paramCount - number of parameter placeholders to generate
 @returns - sql statement
 */
+(NSString*) getInsertShort:(NSString*)table paramCount:(int)paramCount {
    NSMutableString* statement = nil;
    
    if ( table != nil && [table length] > 0 && paramCount > 0 ) {
        
        NSMutableString* temp = [NSMutableString stringWithCapacity:128];
        for (int i = 0; i < paramCount; i++) {
            [temp appendString:@"?,"];
        }
        
        //remove last comma
        [temp deleteCharactersInRange:NSMakeRange([temp length]-1, 1) ];
        
        statement = [NSMutableString stringWithFormat:@"%@%@%@%@%@",
                     SqlGenConsts.CL_INSERT, table, SqlGenConsts.CL_VALUES, temp, SqlGenConsts.CL_CLOSEPRN];
        
        DLogV(@"%@",statement);
    }
    else {
        DLogV(@"Illegal input parameters!");
    }
    
    return [NSString stringWithString:statement];
}


/**
 Generates insert statement using the following format:
 INSERT INTO table (field1,field2...) VALUES (?,?...)
 @param table table name
 @param fieldnames - NSaray of strings with column names to be inserted
 @param paramCount - number of parameter placeholders to generate
 @returns - sql statement
 */

+(NSString*) getInsert:(NSString*)table fieldNames:(NSArray*)fieldNames {
    
    if ( table != nil && [table length] > 0 && fieldNames != nil && [fieldNames count] > 0 ) {
        
        NSMutableString* statement = [NSMutableString stringWithFormat:@"%@%@ (", SqlGenConsts.CL_INSERT, table];
        
        NSMutableString* fields = [NSMutableString stringWithCapacity:512];
        NSMutableString* placeHolders = [NSMutableString stringWithString:SqlGenConsts.CL_VALUES];
        
        for (int i = 0; i < [fieldNames count]; i++) {
            [fields appendFormat:@"%@,", [fieldNames objectAtIndex:i]];
            [placeHolders appendString:@"?,"];
        }
        //replace trailing comma with close parenthice
        fields = [[fields stringByReplacingCharactersInRange:NSMakeRange([fields length]-1, 1)
                                                  withString:SqlGenConsts.CL_CLOSEPRN ] mutableCopy];
        
        placeHolders = [[placeHolders stringByReplacingCharactersInRange:NSMakeRange([placeHolders length]-1, 1)
                                                              withString:SqlGenConsts.CL_CLOSEPRN ] mutableCopy];
        
        [statement appendFormat:@"%@%@", fields, placeHolders];
        
        DLogV(@"%@",statement);
        return statement;
    }
    DLogV(@"Illegal input parameters!");
    return nil;
    
}

/**
 Generates update statement using the following format:
 UPDATE table_name SET column1=?, column2=?,...
 WHERE searchCol1=? and searchCol2=?...
 @param table table name
 @param fieldNames names of the fields to update, string array
 @param searchColNames string array of the search fields to be insluded in where clause, for multiple values
 conditions ar ecombined with AND predicate
 @returns - sql statement
 */
+(NSString*) getUpdateStatement:(NSString*)table fieldNames:(NSArray*)fieldNames searchColNames:(NSArray*)searchColNames {
    
    if ( table != nil && [table length] > 0 && fieldNames != nil && [fieldNames count] > 0 ) {
        
        NSMutableString* statement = [NSMutableString stringWithFormat:@"%@%@%@", SqlGenConsts.CL_UPDATE, table, SqlGenConsts.CL_SET];
        
        for (int i = 0; i < [fieldNames count]; i++) {
            [statement appendFormat:@"%@=?,", [fieldNames objectAtIndex:i]];
        }
        [statement deleteCharactersInRange:NSMakeRange([statement length]-1, 1) ];//delete trailing comma
        
        //add whre clause if search fields were specified
        if ( searchColNames != nil && [searchColNames count] > 0 ) {
            
            [statement appendString:SqlGenConsts.CL_WHERE];//add where keyword here
            
            for (int i = 0; i < [searchColNames count]; i++) {
                [statement appendFormat:@"%@=?%@", [searchColNames objectAtIndex:i], SqlGenConsts.OP_AND];
            }
            int dl = [SqlGenConsts.OP_AND length];//length of the AND operator string
            [statement deleteCharactersInRange:NSMakeRange([statement length]-dl, dl) ];//delete trailing AND
        }
        DLogV(@"%@",statement);
        return statement;
    }
    DLogV(@"Illegal input parameters!");
    return nil;
}

//Simplified, optimized variant for sync fast updates, search spec is always one column id or amdcrowid, cacheable string
+(NSString*) getUpdateStatementByKey:(NSString*)table fieldNames:(NSArray*)fieldNames keyCol:(NSString*)keyCol {
    
    if ( table != nil && [fieldNames count] > 0 ) {
        
        NSMutableString* statement = [NSMutableString stringWithFormat:@"%@%@%@", SqlGenConsts.CL_UPDATE, table, SqlGenConsts.CL_SET];
        
        for (int i = 0; i < [fieldNames count]; i++) {
            [statement appendFormat:@"%@=?,", [fieldNames objectAtIndex:i]];
        }
        [statement deleteCharactersInRange:NSMakeRange([statement length]-1, 1) ];//delete trailing comma
        
        //add where clause if search fields were specified
        if ( keyCol != nil ) {
            
            [statement appendFormat:@"%@ %@=?",SqlGenConsts.CL_WHERE, keyCol];//add where clause here
        }
        DLogV(@"%@",statement);
        return statement;
    }
    DLogV(@"Illegal input parameters!");
    return nil;
}

+(NSString*) getUpdateStatement:(NSString*)table fieldNames:(NSArray*)fieldNames searchSpec:(NSString*)searchSpec {
    
    if ( table != nil && [table length] > 0 && fieldNames != nil && [fieldNames count] > 0 ) {
        
        NSMutableString* statement = [NSMutableString stringWithFormat:@"%@%@%@", SqlGenConsts.CL_UPDATE, table, SqlGenConsts.CL_SET];
        
        for (int i = 0; i < [fieldNames count]; i++) {
            [statement appendFormat:@"%@=?,", [fieldNames objectAtIndex:i]];
        }
        [statement deleteCharactersInRange:NSMakeRange([statement length]-1, 1) ];//delete trailing comma
        
        //add where clause if search fields were specified
        if ( [searchSpec length] > 0 ) {
            [statement appendFormat:@"%@%@", SqlGenConsts.CL_WHERE, searchSpec];
        }
        
        DLogV(@"%@",statement);
        return statement;
    }
    DLogV(@"Illegal input parameters!");
    
    
    return nil;
}


/**
 Generates delete statement using the following format:
 DELETE FORM table_name WHERE searchCol1=? and searchCol2=?...
 @param table table name
 @param searchColNames string array of the search fields to be insluded in where clause, for multiple values
 conditions ar ecombined with AND predicate
 @returns - sql statement
 */
+(NSString*) getDeleteStatement:(NSString*)table searchColNames:(NSArray*)searchColNames {
    
    if ( table != nil && [table length] > 0 ) {
        
        NSMutableString* statement = [NSMutableString stringWithFormat:@"%@%@", SqlGenConsts.CL_DELETE, table];
        
        //add whre clause if search fields were specified
        if ( searchColNames != nil && [searchColNames count] > 0 ) {
            
            [statement appendString:(NSString*)SqlGenConsts.CL_WHERE];//add where keyword here
            
            for (int i = 0; i < [searchColNames count]; i++) {
                [statement appendFormat:@"%@=?%@", [searchColNames objectAtIndex:i], SqlGenConsts.OP_AND];
            }
            int dl = [SqlGenConsts.OP_AND length];//length of the AND operator string
            [statement deleteCharactersInRange:NSMakeRange([statement length]-dl, dl) ];//delete trailing AND
        }
        DLogV(@"%@",statement);
        return statement;
    }
    DLogV(@"Illegal input parameters!");
    return nil;
    
}

+(NSString*) getDeleteStatement:(NSString*)table searchSpec:(NSString*)searchSpec {
    
    if ( table != nil && [table length] > 0 ) {
        
        NSMutableString* statement = [NSMutableString stringWithFormat:@"%@%@", SqlGenConsts.CL_DELETE, table];
        //add where clause if search fields were specified
        if ( [searchSpec length] > 0 ) {
            [statement appendFormat:@"%@%@", SqlGenConsts.CL_WHERE, searchSpec];
        }
        
        DLogV(@"%@",statement);
        return statement;
    }
    DLogV(@"Illegal input parameters!");
    return nil;
}


+(NSString*) getQueryStatement:(NSString*)table joinDefs:(NSArray*)joins
                    fieldNames:(NSArray*)fieldNames searchSpec:(NSString*)searchSpec
                      sortCols:(NSArray*)sortCols groupBy:(NSArray*)groupBy
                         limit:(int)limit offset:(int)offset {
    
    if ( table != nil && [table length] > 0 ) {
        
        NSString* fieldNameStr = SqlGenConsts.SQL_STAR;//by default we select all of the fields
        
        //if field list was specified, generate CSV string with fieldnames
        if ( fieldNames != nil && [fieldNames count] > 0 ) {
            fieldNameStr = [self fieldNameArray2String:fieldNames];
        }
        
        NSString* tableList = table;
        
        if ( [joins count] > 0 ) {
            
            NSMutableString* temp = [NSMutableString stringWithCapacity:512];
            for ( int i = 0; i < [joins count]; i++ ) {
                [temp appendString:[(TXJoinDef*)[joins objectAtIndex:i] joinDefToSQLStr]];
            }
            //now combine our table name with the joined table names and conditions
            //e.g. from accounts join opptys on accounts.id=opptys.accountid join...
            tableList = [NSString stringWithFormat:@"%@%@", table, temp];
        }
        
        NSMutableString* statement = [NSMutableString stringWithFormat:@"%@%@%@%@", SqlGenConsts.CL_SELECT, fieldNameStr, SqlGenConsts.CL_FROM, tableList];
        
        //add where clause if search fields were specified
        if ( [searchSpec length] > 0 ) {
            [statement appendFormat:@"%@%@", SqlGenConsts.CL_WHERE, searchSpec];
        }
        
        //append sort columns if any
        if ( [groupBy count] > 0 ) {
            NSString* groupSPec = [self fieldNameArray2String:groupBy];
            [statement appendFormat:@"%@%@", SqlGenConsts.CL_GROUPBY, groupSPec];
        }
        
        //append sort columns if any
        if ( [sortCols count] > 0 ) {
            NSString* sortSpec = [self fieldNameArray2String:sortCols];
            [statement appendFormat:@"%@%@", SqlGenConsts.CL_ORDERBY, sortSpec];
        }
        
        if ( limit > 0 )
            [statement appendFormat:@"%@%d", SqlGenConsts.CL_LIMIT, limit];
        
        if ( offset > 0 )
            [statement appendFormat:@"%@%d", SqlGenConsts.CL_OFFSET, offset];
        
        
        DLogV(@"%@",statement);
        return statement;
    }
    DLogV(@"Illegal input parameters!");
    return nil;
}


/**
 Generates query statement using the following format:
 SELECT field1, field2...  from table_name WHERE searchCol1=? and searchCol2=?...
 @param table table name
 @param fieldNames names of the fields to retreive, string/aggregate object array
 if field list isn't empty join def fields are ignored
 @param searchColNames string array of the search fields to be insluded in where clause, for multiple values
 conditions are combined with AND predicate
 @returns - sql statement
 */

+(NSString*) getQueryStatement:(NSString*)table joinDefs:(NSArray*)joins
                    fieldNames:(NSArray*)fieldNames searchColNames:(NSArray*)searchColNames
                      sortCols:(NSArray*)sortCols groupBy:(NSArray*)groupBy
                         limit:(int)limit offset:(int)offset {
    
    if ( table != nil && [table length] > 0 ) {
        NSMutableString* srchSpec = nil;
        
        if ( searchColNames != nil && [searchColNames count] > 0 ) {
            srchSpec = [NSMutableString stringWithCapacity:512];
            
            for (int i = 0; i < [searchColNames count]; i++) {
                [srchSpec appendFormat:@"%@=?%@", [searchColNames objectAtIndex:i], SqlGenConsts.OP_AND];
            }
            int dl = [SqlGenConsts.OP_AND length];//length of the AND operator string
            [srchSpec deleteCharactersInRange:NSMakeRange([srchSpec length]-dl, dl) ];//delete trailing AND
        }
        
        return [self getQueryStatement:table joinDefs:joins fieldNames:fieldNames searchSpec:srchSpec
                              sortCols:sortCols groupBy:groupBy limit:limit offset:offset];
    }
    return nil;
}


+(NSString*) fieldNameArray2String:(NSArray*)fieldNames {
    
    NSString* retVal = nil;
    
    NSMutableString* fldList = [NSMutableString stringWithCapacity:512];
    
    if ( [fieldNames count] > 0 ) {
        
        //field names contains either string name or agregate object.
        //strings are appended as they are, agregates are appended by string they generate from aggregateToSQLStr function
        for ( id fieldObj in fieldNames ) {
            if ( [fieldObj isKindOfClass:[NSString class]] ) {
                [fldList appendFormat:@"%@,", (NSString*)fieldObj];
            }
            else if ( [fieldObj isKindOfClass:[TXAggregateField class]] ) {
                [fldList appendFormat:@"%@,", [(TXAggregateField*)fieldObj aggregateToSQLStr]];
            } else {
                DLogV(@"%@ - %@", LocalizedStr(@"DAO.err.invalidFieldObj"), fieldObj);
            }
        }
        //remove last comma
        retVal = [fldList substringToIndex:[fldList length]-1];
    }
    
    return retVal;
}

+(NSString*) getRowExistsStatement:(NSString*)table searchSpec:(NSString*)searchSpec {
    
    if ( [table length] > 0 ) {
        
        NSMutableString* statement = [NSMutableString stringWithFormat:@"SELECT count(1) FROM %@ WHERE %@ LIMIT 1",
                                      table, searchSpec];
        
        DLogV(@"%@",statement);
        return statement;
    }
    DLogV(@"Illegal input parameters!");
    return nil;
}

@end
