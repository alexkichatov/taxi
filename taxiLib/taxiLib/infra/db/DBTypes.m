//
//  DBTypes.m
//  taxiLib
//
//  Created by Irakli Vashakidze on 02/11/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "utils.h"
#import "DBTypes.h"
#import "StrConsts.h"

const int O_NOOPCODE = -1;

const int O_VALUE_CHANGED = 4;
const int O_QUERY = 5;
const int O_SUBSCRIBE = 6;
const int O_UNSUBSCRIBE = 7;
const int O_FAIL = 8;

NSString* const JT_INNER        = @"INNER";
NSString* const JT_LEFTOUTER    = @"LEFT OUTER";
NSString* const JT_CROSS        = @"CROSS";

@implementation TXAggregateField

+(TXAggregateField*) aggregateFuncField:(NSString*) funcName onField:(NSString*) fieldName {
    
    TXAggregateField* aggregate = nil;
    
    if ( [funcName length] > 0 && [fieldName length] > 0 ) {
        
        if ( funcName == SqlAggKeyWords.AGG_COUNT || funcName == SqlAggKeyWords.AGG_AVG || funcName == SqlAggKeyWords.AGG_SUM ||
            funcName == SqlAggKeyWords.AGG_MIN || funcName == SqlAggKeyWords.AGG_MAX) {
            
            aggregate = [[TXAggregateField alloc] init];
            aggregate.aggregateFunc = funcName;
            aggregate.field = fieldName;
        }
    }
    
    return aggregate;
}

-(NSString*) aggregateToSQLStr {
    
    NSString* sqlStr = nil;
    
    if ( [self.aggregateFunc length] > 0 && [self.field length] > 0 ) {
        sqlStr = [NSString stringWithFormat:@"%@(%@)", self.aggregateFunc, self.field];
    }
    return sqlStr;
}

@end


@implementation TXJoinDef

+(TXJoinDef*) joinDefOnObjects:(NSString*) pObjLeft objRight:(NSString*)pObjRight
                          idleft:(NSArray*) pidFieldLeft idRight:(NSArray*)pidFieldRight
                        joinType:(NSString*)pjoinType  {
    TXJoinDef* joinDef = nil;
    
    if ( [pObjLeft length] > 0 && [pObjRight length] > 0 &&
        [pidFieldLeft count] > 0 && [pidFieldRight count] > 0 ) {
        
        joinDef = [[TXJoinDef alloc] init];
        joinDef.daoLeft = pObjLeft;
        joinDef.daoRight = pObjRight;
        joinDef.idFieldLeft = pidFieldLeft;
        joinDef.idFieldRight = pidFieldRight;
        
        //default join type is inner join.
        if ( pjoinType == nil )
            joinDef.type = JT_INNER;
        else if (pjoinType == JT_LEFTOUTER || pjoinType == JT_INNER || pjoinType == JT_CROSS  )
            joinDef.type = pjoinType;
        else {
            DLogE( LocalizedStr(@"Db.err.unsupportedJoinType"), pjoinType);
        }
    }
    else {
        DLogE( @"%@", LocalizedStr(@"Db.err.illagelJoinDefParams") );
    }
    
    return joinDef;
}
/**
 creates string like " daoT1.f1 = daoT2.f1 [ { AND daoT1.f2 = daoT2.f2 } ... ] "         becusnaur format for descr.
 for JOIN daoT2 ON () clause   from AMDCJoinDef object or from joinCondition string  , i.e. one of them, last one have priority to first one.
 */
-(NSString*) joinDefToSQLStr {
    NSString* joinStr = nil;
    
    if ( [self.joinCondition length] > 0 || ( [self.daoLeft length] > 0 && [self.daoRight length] > 0 &&
                                             [self.idFieldLeft count] > 0 && [self.idFieldRight count] == [self.idFieldLeft count] )) {
        
        if ( [self.joinCondition length] > 0 ) { // if joinCondition exists, it has priority
            joinStr = self.joinCondition;
        }
        else {
            NSMutableString* tempstr = [NSMutableString stringWithString:@""];
            for ( int i = 0; i < [self.idFieldLeft count]; i++) {
                NSString* lFN = [self.idFieldLeft[i] stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceCharacterSet]];
                NSString* rFN = [self.idFieldRight[i] stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceCharacterSet]];
                BOOL hpL = [lFN hasPrefix:@"'"] || [lFN hasPrefix:@"\""];
                BOOL hpR = [rFN hasPrefix:@"'"] || [rFN hasPrefix:@"\""];
                [tempstr appendFormat:@"%@%@%@%@%@%@%@%@",i>0?SqlGenConsts.OP_AND:@"",hpL?@"":self.daoLeft,hpL?@"":SqlGenConsts.SQL_DOT,lFN,SqlGenConsts.OP_EQ,hpR?@"":self.daoRight,hpR?@"":SqlGenConsts.SQL_DOT,rFN];
            }
            joinStr = [NSString stringWithFormat:@" %@%@%@%@%@%@%@", self.type, SqlGenConsts.CL_JOIN, self.daoRight, SqlGenConsts.CL_ON,
                       SqlGenConsts.CL_OPENPRN, tempstr, SqlGenConsts.CL_CLOSEPRN ];
        }
    }
    
    return joinStr;
}

@end