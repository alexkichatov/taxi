//
//  TXObjectPDQCriteria.h
//  TX
//
//  Created by Alexander Sharov on 10/1/13.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    PDQUnknownCriteria,
    PDQEqualCriteria,
    PDQStartWithCriteria,
    PDQEndsWithCriteria,
    PDQContainsCriteria,
    PDQGreatCriteria,
    PDQGreatEqualCriteria,
    PDQLessThenCriteria,
    PDQLessEqualCriteria,
    PDQNotEqualCriteria,
    PDQPriorToCriteria,
    PDQInLastCriteria,
    PDQInCriteria
} kPDQCriteriaCondition;

typedef enum {
    PDQUnknownType,
    PDQEnumType,
    PDQNumberType,
    PDQDateType,
    PDQStringType
} kPDQCriteriaType;

@interface TXObjectPDQCriteria : NSObject <NSCoding>

/*
* {
 field:"field_name from jsone"
 condition:"из твоего енума"
 value: "собствено велью"
 lovValue:["","",""]
 measure:"hh, mm…"
 type:"str/date/num/lov"
}
*
* */

-(id)initWithDict:(NSDictionary *)dict;

-(NSPredicate *)criteriaPredicateWithObject:(NSString*)objectType;

@property (nonatomic, copy) NSString *fieldName;

@property (nonatomic, copy) NSString *fieldValue;

@property (nonatomic, strong) NSArray *lovValues;

@property (nonatomic, copy) NSString *measureStr;

@property (nonatomic) kPDQCriteriaType criteriaType;

@property (nonatomic) kPDQCriteriaCondition criteriaCondition;





@end
