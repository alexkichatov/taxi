//
//  TXObjectPDQ.m
//  TX
//
//  Created by Alexander Sharov on 10/1/13.
//
//

#import "TXObjectPDQ.h"
#import "TXObjectPDQCriteria.h"

@implementation TXObjectPDQ

@synthesize name, type, criterias;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:name forKey:@"pdqName"];
    [aCoder encodeObject:type forKey:@"pdqType"];
    [aCoder encodeObject:criterias forKey:@"criterias"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [self init])){
        self.name = [aDecoder decodeObjectForKey:@"pdqName"];
        self.type = [aDecoder decodeObjectForKey:@"pdqType"];
        self.criterias = [aDecoder decodeObjectForKey:@"criterias"];
    }

    return self;
}

-(id)initWithJsonDict:(NSDictionary *)dict{
    if (self = [self init]){
        self.name = [dict objectForKey:@"name"];
        if (![self.name isKindOfClass:[NSString class]])
            self.name = nil;

        self.type = [dict objectForKey:@"object"];
        if (![self.type isKindOfClass:[NSString class]])
            self.type = nil;

        self.criterias = [self criteriasFrom:[dict objectForKey:@"criterias"]];
    }

    return self;
}

-(NSArray*)criteriasFrom:(NSArray*)critDicts{
    NSMutableArray *newCriterias = [NSMutableArray array];
    for (NSDictionary *critDict in critDicts){
        TXObjectPDQCriteria *criteria = [[TXObjectPDQCriteria alloc] initWithDict:critDict];
        if (criteria)
            [newCriterias addObject:criteria];
    }
    return newCriterias;
}


-(NSPredicate*)predicate{
    NSMutableArray *criteriaPredicates = [NSMutableArray array];

    for (TXObjectPDQCriteria *criteria in self.criterias){
        NSPredicate *pred = [criteria criteriaPredicateWithObject:self.type];
        if (pred)
            [criteriaPredicates addObject:pred];
    }

    NSPredicate *resPredicate = nil;
    if ([criteriaPredicates count] == 1)
        resPredicate = [criteriaPredicates lastObject];
    else if ([criteriaPredicates count] > 1)
        resPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:criteriaPredicates];

    return resPredicate;
}

@end
