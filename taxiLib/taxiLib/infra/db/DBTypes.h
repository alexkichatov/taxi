//
//  DBTypes.m
//  taxiLib
//
//  Created by Irakli Vashakidze on 02/11/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_FLOAT_PRECISION 2

extern const int O_NOOPCODE;
extern const int O_INSERT;
extern const int O_UPDATE;
extern const int O_DELETE;
extern const int O_VALUE_CHANGED;
extern const int O_QUERY;
extern const int O_SUBSCRIBE;
extern const int O_UNSUBSCRIBE;
extern const int O_FAIL;

@interface TXAggregateField:NSObject {
    
}

@property (strong, nonatomic) NSString* field;
@property (strong, nonatomic) NSString* aggregateFunc;

+(TXAggregateField*) aggregateFuncField:(NSString*) funcName onField:(NSString*) fieldName;

-(NSString*) aggregateToSQLStr;

@end




extern NSString* const JT_INNER;
extern NSString* const JT_LEFTOUTER;
extern NSString* const JT_CROSS;

/**
 Defines join between the two DAOs.
 idFieldLeft and field two are the fields for join on condition.
 idFieldRight is the array of the fields which can be field names or aggregates, or a combinatino of both.
 */
@interface TXJoinDef:NSObject {
    
}

@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSString* daoLeft;
@property (strong, nonatomic) NSString* daoRight;
@property (strong, nonatomic) NSArray* idFieldLeft;
@property (strong, nonatomic) NSArray* idFieldRight;
@property (strong, nonatomic) NSArray*  fieldList;
@property (strong, nonatomic) NSString*  joinCondition;


/**
 creates join definition based on input params. Standard param check is performed. All
 parameters are mandatory.
 */
+(TXJoinDef*) joinDefOnObjects:(NSString*) pObjLeft objRight:(NSString*)pObjRight
                          idleft:(NSArray*) pidFieldLeft idRight:(NSArray*)pidFieldRight
                        joinType:(NSString*)pjoinType;
/**
 creates string like " daoT1.f1 = daoT2.f1 [ { AND daoT1.f2 = daoT2.f2 } ... ] "         becusnaur format for descr.
 for JOIN daoT2 ON () clause   from AMDCJoinDef object or from joinCondition string  , i.e. one of them, last one have priority to first one.
 */
-(NSString*) joinDefToSQLStr;

@end