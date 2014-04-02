//
//  TXObjectPDQCriteria.m
//  TX
//
//  Created by Alexander Sharov on 10/1/13.
//
//

#import "TXObjectPDQCriteria.h"

@implementation TXObjectPDQCriteria
@synthesize fieldName, fieldValue, lovValues, measureStr, criteriaType, criteriaCondition;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:fieldName forKey:@"fieldName"];
    [aCoder encodeObject:fieldValue forKey:@"fieldValue"];
    [aCoder encodeObject:lovValues forKey:@"lovValues"];
    [aCoder encodeObject:measureStr forKey:@"measureStr"];
    [aCoder encodeObject:[NSNumber numberWithInt:criteriaType] forKey:@"criteriaType"];
    [aCoder encodeObject:[NSNumber numberWithInt:criteriaCondition] forKey:@"criteriaCondition"];

}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [self init])){
        self.fieldName = [aDecoder decodeObjectForKey:@"fieldName"];
        self.fieldValue = [aDecoder decodeObjectForKey:@"fieldValue"];
        self.lovValues = [aDecoder decodeObjectForKey:@"lovValues"];
        self.measureStr = [aDecoder decodeObjectForKey:@"measureStr"];

        self.criteriaType = (kPDQCriteriaType)[[aDecoder decodeObjectForKey:@"criteriaType"] intValue];
        self.criteriaCondition = (kPDQCriteriaCondition)[[aDecoder decodeObjectForKey:@"criteriaCondition"] intValue];

    }

    return self;
}


-(id)initWithDict:(NSDictionary *)dict{
    if (self = [self init]){
        [self updateObjectWithDictionary:dict];
    }

    return self;
}

-(kPDQCriteriaCondition)criteriaConditionFromStr:(NSString*)conditionStr{
    kPDQCriteriaCondition critCond = PDQUnknownCriteria;

    if (![conditionStr isKindOfClass:[NSString class]])
        critCond = PDQUnknownCriteria;
    else if ([conditionStr isEqualToString:@"equal"]){
        critCond = PDQEqualCriteria;
    } else if ([conditionStr isEqualToString:@"start.with"]){
        critCond = PDQStartWithCriteria;
    } else if ([conditionStr isEqualToString:@"ends.with"]){
        critCond = PDQEndsWithCriteria;
    } else if ([conditionStr isEqualToString:@"contains"]){
        critCond = PDQContainsCriteria;
    } else if ([conditionStr isEqualToString:@"eq"]){
        critCond = PDQEqualCriteria;
    } else if ([conditionStr isEqualToString:@"gt"]){
        critCond = PDQGreatCriteria;
    } else if ([conditionStr isEqualToString:@"ge"]){
        critCond = PDQGreatEqualCriteria;
    } else if ([conditionStr isEqualToString:@"lt"]){
        critCond = PDQLessThenCriteria;
    } else if ([conditionStr isEqualToString:@"le"]){
        critCond = PDQLessEqualCriteria;
    } else if ([conditionStr isEqualToString:@"ne"]){
        critCond = PDQNotEqualCriteria;
    } else if ([conditionStr isEqualToString:@"prior.to"]){
        critCond = PDQPriorToCriteria;
    } else if ([conditionStr isEqualToString:@"in.last"]){
        critCond = PDQInLastCriteria;
    } else if ([conditionStr isEqualToString:@"not.equal"]){
        critCond = PDQNotEqualCriteria;
    } else if ([conditionStr isEqualToString:@"in"]){
        critCond = PDQInCriteria;
    }

    return critCond;
}

-(kPDQCriteriaType)criteriaTypeFromStr:(NSString*)criteriaTypeStr{
    if (![criteriaTypeStr isKindOfClass:[NSString class]])
        return PDQUnknownType;

    kPDQCriteriaType crType = PDQUnknownType;
    if ([criteriaTypeStr isEqualToString:@"Number"]){
        crType = PDQNumberType;
    } else if ([criteriaTypeStr isEqualToString:@"Enum"]){
        crType = PDQEnumType;
    } else if ([criteriaTypeStr isEqualToString:@"Date"]){
        crType = PDQDateType;
    } else if ([criteriaTypeStr isEqualToString:@"String"]){
        crType = PDQStringType;
    }

    return crType;
}



-(void)updateObjectWithDictionary:(NSDictionary *)dict{
    /* Field Name */
    self.fieldName = [dict objectForKey:@"field"];
    if (![self.fieldName isKindOfClass:[NSString  class]])
        self.fieldName = nil;
    else if ([self.fieldName isEqualToString:@"lTSubStatusCode"])
        self.fieldName = @"ltsubStatusCode";

    self.criteriaCondition = [self criteriaConditionFromStr:[dict objectForKey:@"condition"]];


    /* Field Value */
    self.fieldValue = [dict objectForKey:@"value"];
    if (![self.fieldValue isKindOfClass:[NSString  class]])
        self.fieldValue = nil;

    self.criteriaType = [self criteriaTypeFromStr:[dict objectForKey:@"type"]];

    self.measureStr = [dict objectForKey:@"measure"];
    if (![self.measureStr isKindOfClass:[NSString  class]])
        self.measureStr = nil;

    self.lovValues = [dict objectForKey:@"listOfValues"];
    if (![self.lovValues isKindOfClass:[NSArray class]])
        self.lovValues = nil;

}

-(NSDictionary *)mappingDictionaryForType:(NSString*)objectType{
    NSDictionary *mappingDictionary = nil;
//    if ([objectType isEqualToString:@"Account"]){
//        mappingDictionary = [TXAccount mappingDictionary];
//    } else if ([objectType isEqualToString:@"Contact"]){
//        mappingDictionary = [Contact mappingDictionary];
//    } else if ([objectType isEqualToString:@"Quote"]){
//        mappingDictionary = [Quote mappingDictionary];
//    } else if ([objectType isEqualToString:@"Opportunity"] ||
//                [objectType isEqualToString:@"Lead"]){
//        mappingDictionary = [Opportunity mappingDictionary];
//    } else if ([objectType isEqualToString:@"Asset"]){
//        mappingDictionary = [Asset mappingDictionary];
//    } else if ([objectType isEqualToString:@"Activity"]){
//        mappingDictionary = [Activity mappingDictionary];
//    } else if ([objectType isEqualToString:@"SampleDemo"]){
//        mappingDictionary = [Sample mappingDictionary];
//    }

    return mappingDictionary;
}

-(NSString*)localFieldNameFor:(NSString*)objectType andFieldName:(NSString*)servFieldName{
    NSDictionary *mappingDictionary = [self mappingDictionaryForType:objectType];
    if (!mappingDictionary)
        return servFieldName;

    NSArray *allKeys = [mappingDictionary allKeys];
    for (NSString *key in allKeys){
        NSString *localField = [mappingDictionary objectForKey:key];
        if ([localField isEqualToString:servFieldName])
            return key;
    }

    return servFieldName;
}

-(NSString*)operationString{
    NSString *operString = nil;
    switch (self.criteriaCondition){
        case    PDQUnknownCriteria:
            operString = @"%K = %@";
            break;
        case    PDQEqualCriteria:
            operString = @"%K = %@";
            break;
        case    PDQStartWithCriteria:
            operString = @"%K BEGINSWITH[cd] %@";
            break;
        case    PDQEndsWithCriteria:
            operString = @"%K ENDSWITH[cd]  %@";
            break;
        case    PDQContainsCriteria:
            operString = @"%K CONTAINS[cd] %@";
            break;
        case    PDQGreatCriteria:
            operString = @"%K > %@";
            break;
        case    PDQGreatEqualCriteria:
            operString = @"%K >= %@";
            break;
        case    PDQLessThenCriteria:
            operString = @"%K < %@";
            break;
        case    PDQLessEqualCriteria:
            operString = @"%K <= %@";
            break;
        case    PDQNotEqualCriteria:
            operString = @"%K <> %@";
            break;
        case    PDQPriorToCriteria:
            operString = @"%K <= %@";
            break;
        case    PDQInLastCriteria:
            operString = @"%K >= %@";
            break;
        case    PDQInCriteria:
            operString = @"%K IN %@";
            break;
        default:
            operString = @"%K = %@";
            break;
    }

    return operString;
}

-(NSTimeInterval)secsInMeasure:(NSString*)measStr{



    if ([measStr isEqualToString:@"Seconds"])
        return 1;
    else if ([measStr isEqualToString:@"Minutes"])
        return 60;
    else if ([measStr isEqualToString:@"Hours"])
        return 3600;
    else if ([measStr isEqualToString:@"Days"])
        return 3600*24;
    else if ([measStr isEqualToString:@"Weeks"])
        return 3600*24*7;
    else if ([measStr isEqualToString:@"Months"])
        return 3600*24 * 30;
    else if ([measStr isEqualToString:@"Quarters"])
        return 3600*24 * 30 * 4;
    else if ([measStr isEqualToString:@"Years"])
        return 3600* 24 * 30 * 12;

    return 0;
}

-(id)valueString{
    if (self.criteriaType == PDQEnumType){
        if (self.criteriaCondition == PDQEqualCriteria){
            return [self.lovValues lastObject];
        } else {
            return self.lovValues;
        }
    } else if (self.criteriaType == PDQDateType){
        NSTimeInterval timeInt = [self.fieldValue intValue] * [self secsInMeasure:self.measureStr];
        return [NSDate dateWithTimeIntervalSinceNow:-timeInt];
    } else if (self.criteriaType == PDQNumberType){
        return [NSNumber numberWithLongLong:[self.fieldValue longLongValue]];
    }

    return self.fieldValue;
}

-(NSPredicate *)criteriaPredicateWithObject:(NSString*)objectType{

    NSString *localFieldName = [self localFieldNameFor:objectType andFieldName:fieldName];

    NSString *formatStr = [self operationString];

    id valObj = [self valueString];

    if (localFieldName == nil
        || formatStr == nil
        || valObj == nil)
        return nil;

    NSPredicate *critPredicate = [NSPredicate predicateWithFormat:formatStr, localFieldName, valObj];

    return critPredicate;
}


@end
