//
//  TXDataInputProtocol.h
//  CRM
//
//  Created by Alexander Sharov on 18/12/13.
//  Copyright (c) 2013 LifeTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TXDataInputProtocol <NSObject>

-(void)finalyzeChanges; /* should be called before save to be sure that data is saved correctly s*/
@end
