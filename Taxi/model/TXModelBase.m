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
        self->application = [TXVM instance];
    }
    
    return self;
}

-(void)onRequestCompleted:(id)object {
    NSLog(@"onRequestCompleted not implemented");
}

-(void)onFail:(id)object error:(TXError *)error {
    NSLog(@"onFail not implemented");
}

-(TXRequestObj *)createRequest:(NSString *)config {
    return [TXRequestObj initWithConfig:config andListener:self];
}

-(void)sendAsyncRequest:(TXRequestObj *) request {
    [self->httpMgr sendAsyncRequest:request];
}

@end
