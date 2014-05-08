//
//  TXUserSignInBase.h
//  Taxi
//
//  Created by Irakli Vashakidze on 4/26/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXRootVC.h"
#import "TXUserModel.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface TXUserSignInBase : TXRootVC<GPPSignInDelegate> {
    TXUser *user;
    TXUserModel *model;
}

@property (nonatomic, strong) GPPSignIn     *signIn;
@property (nonatomic, strong) GTLPlusPerson *googlePerson;

@end
