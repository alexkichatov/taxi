//
//  TXModelBase.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXModelBase.h"

@implementation TXModelBase

-(id)init {
    
    if(self = [super init]) {
        self->httpMgr     = [TXHttpRequestManager instance];
        self->application = [TXApp instance];
    }
    
    return self;
}

-(void)onRequestCompleted:(id)object {
    
}

-(void)onFail:(id)object error:(TXError *)error {
    
}

@end
