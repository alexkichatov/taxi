//
//  TXRootVC.h
//  Taxi
//
//  Created by Irakli Vashakidze on 3/2/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXCode2MsgTranslator.h"
#import "TXModelBase.h"
#import "TXUILayers.h"
#import "TXTextField.h"
#import "TXButton.h"

@interface TXBaseViewController : UIViewController<TXEventListener> {
    NSDictionary *parameters;
    float x;
    float y;
    float width;
    float height;
}

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void) pushViewController : (TXBaseViewController *) viewController;
-(void) alertError : (NSString *) title message : (NSString *) message;
-(TXBaseViewController *) vcFromName: (NSString *) name;
-(void)refreshInterfaceBasedOnSignIn;
-(void) setParameters:(NSDictionary *)props;
-(void) showBusyIndicator;
-(void) showBusyIndicator:(NSString *)title;
-(void) hideBusyIndicator;
-(void) configure;
-(void) configureStyles;
-(UIView*)backroundView;
@end
