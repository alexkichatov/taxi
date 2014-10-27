//
//  TXModelBase.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXHttpRequestManager.h"
#import "TXEventTarget.h"
#import "StrConsts.h"
#import "utils.h"
#import "TXApp.h"

@interface TXResponseDescriptor : NSObject

@property (nonatomic, assign) BOOL      success;
@property (nonatomic, assign) int       code;
@property (nonatomic, weak)   NSString* message;
@property (nonatomic, weak)   id        source;

+(id) create:(BOOL) succcess_ code:(int) code_ message:(NSString *) message_ source:(id) source_;
+(id) create:(BOOL) succcess_ code:(int) code_;

@end

@class TXSharedObj;

@interface TXModelBase : TXEventTarget <TXHttpRequestListener, TXEventListener> {
    TXHttpRequestManager *httpMgr;
}

@property (nonatomic, strong) TXSharedObj *application;

-(TXRequestObj *) createRequest:(NSString *) config;
-(void)sendAsyncRequest:(TXRequestObj *) request;
-(id)sendSyncRequest:(TXRequestObj *) request;
-(TXApp *)getApp;
-(void)onRequestCompleted:(id)object;
-(void)onFail:(id)object error:(TXError *)error;

@end
