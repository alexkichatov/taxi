//
//  NSString+TXNSString.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/20/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TXNSString)

-(NSString *) substringUpToFirstOccurance : (char) c;
-(NSString *) substringFromFirstOccurance : (char) c;
-(NSString *) substringUpToLastOccurance : (char) c;
-(NSString *) substringFromRightFromCharacter : (char) c;
-(NSString *) substringFromRightToCharacter : (char) c;
-(NSString *) substringFromLastOccurance: (NSString *) str;

-(int)indexOf:(char)c;
- (BOOL) containsString: (NSString*) substring;

@end
