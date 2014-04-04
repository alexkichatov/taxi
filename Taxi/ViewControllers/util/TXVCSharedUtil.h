//
//  TXVCSharedUtil.h
//  Taxi
//
//  Created by Irakli Vashakidze on 2/24/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXVCSharedUtil : NSObject

+(TXVCSharedUtil*) instance;
-(UIStoryboard*)currentStoryBoard;

@end
