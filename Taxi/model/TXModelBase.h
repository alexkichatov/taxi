//
//  TXModelBase.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXHttpRequestManager.h"
#import "taxiLib/TXEventTarget.h"
#import "TXSharedObj.h"
#import "TXConsts.h"
#import "taxiLib/utils.h"

@interface TXModelBase : TXEventTarget <TXHttpRequestListener> {
    TXHttpRequestManager *httpMgr;
}

@property (nonatomic, strong) TXSharedObj *application;

-(TXRequestObj *) createRequest:(NSString *) config;
-(void)sendAsyncRequest:(TXRequestObj *) request;
-(id)sendSyncRequest:(TXRequestObj *) request;
-(void)onRequestCompleted:(id)object;
-(void)onFail:(id)object error:(TXError *)error;

@end
