//
//  TXUser.m
//  taxiLib
//
//  Created by Irakli Vashakidze on 1/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXUser.h"
#import "utils.h"

@implementation TXUser

@synthesize password = password_;

-(void)setPassword:(NSString *)password {
    self->password_ = password;
}

-(NSString *)getPassword {
   return getHexString(getSHA256([NSString stringWithFormat:@"%@%@", self.username, self->password_]));
}

@end
