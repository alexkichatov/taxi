//
//  NSString+TXNSString.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/20/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "NSString+TXNSString.h"

@implementation NSString (TXNSString)

-(NSString *) substringUpToFirstOccurance : (char) c {
    NSRange range = [self rangeOfString:[NSString stringWithFormat:@"%c", c]];
    return [self substringFromIndex:range.location+1];
}

-(NSString *) substringFromFirstOccurance : (char) c {
    NSRange range = [self rangeOfString:[NSString stringWithFormat:@"%c", c]];
    return [self substringToIndex:range.location];
}

-(NSString *) substringUpToLastOccurance : (char) c {
    NSRange range = [self rangeOfString:[NSString stringWithFormat:@"%c", c] options:NSBackwardsSearch];
    return [self substringFromIndex:range.location+1];
}

-(NSString *) substringFromRightFromCharacter : (char) c {
    NSRange range = [self rangeOfString:[NSString stringWithFormat:@"%c", c] options:NSBackwardsSearch];
    return [self substringToIndex:range.location];
}

-(NSString *) substringFromLastOccurance: (NSString *) str {
    NSRange range = [self rangeOfString:str];
    return [self substringFromIndex:(range.location + range.length)];
}

-(int)indexOf:(char)c {
	
    NSRange range = [self rangeOfString:[NSString stringWithFormat:@"%c", c] options:NSBackwardsSearch];
    return range.location;
}

- (BOOL) containsString: (NSString*) substring
{
    NSRange range = [self rangeOfString : substring];
    BOOL found = ( range.location != NSNotFound );
    return found;
}

@end
