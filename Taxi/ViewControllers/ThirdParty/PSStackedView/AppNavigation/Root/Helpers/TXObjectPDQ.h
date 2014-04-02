//
//  TXObjectPDQ.h
//  TX
//
//  Created by Alexander Sharov on 10/1/13.
//
//

#import <Foundation/Foundation.h>

@interface TXObjectPDQ : NSObject <NSCoding>


@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSArray *criterias;

-(id)initWithJsonDict:(NSDictionary *)dict;

-(NSPredicate*)predicate;

@end
