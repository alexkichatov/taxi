//
//  TXDBHelper.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/20/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXDBHelper : NSObject

+(TXDBHelper *) mainDB;

/*!@function executeQuery
 * Executes the query with spcified query string (with parameters map)
 @param queryStr
 @param arguments
 @return NSArray.
 */
-(NSArray *) executeQuery : (NSString *) queryStr withParameterDictionary:(NSDictionary *)arguments;

/*!@function executeUpdate
 * Executes the sql string with specified parameters in arguments array
 @param sqlStr
 @param arguments
 @return BOOL
 */
-(BOOL) executeUpdate : (NSString *) sqlStr withArgumentsInArray:(NSArray *)arguments;

-(int) close;

@end
