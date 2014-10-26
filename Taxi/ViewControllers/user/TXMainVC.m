//
//  TXMainVC.m
//  Taxi
//
//  Created by Irakli Vashakidze on 4/2/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXMainVC.h"
#import "MenuViewController.h"
#import "TXSharedObj.h"
#import "SVProgressHUD.h"
#import "TXUserModel.h"
#import "TXSignInVC.h"

@interface TXMainVC () {
    NSString *userToken;
}

@end

@implementation TXMainVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithToken:(NSString *) token
{
    self = [self init];
    if (self) {
        self->userToken = token;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [SVProgressHUD showWithStatus:@"Loading ... " maskType:SVProgressHUDMaskTypeBlack];
    [[TXUserModel instance] addEventListener:self forEvent:TXEvents.AUTHWITHTOKEN eventParams:nil];
    [[TXUserModel instance] authWithToken:self->userToken];
    
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
	return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
	return NO;
}

-(void)onEvent:(TXEvent *)event eventParams:(id)subscriptionParams {
    
    [SVProgressHUD dismiss];
    TXResponseDescriptor *descriptor = [event getEventProperty:TXEvents.Params.DESCRIPTOR];
    if(descriptor.success) {
        MenuViewController *leftMenu = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        [SlideNavigationController sharedInstance].leftMenu = leftMenu;
        
        // Creating a custom bar button for right menu
        UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [button setImage:[UIImage imageNamed:@"menu-alt"] forState:UIControlStateNormal];
        [button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [SlideNavigationController sharedInstance].leftBarButtonItem = leftBarButtonItem;
    } else {
        TXSignInVC *signInVC = [[TXSignInVC alloc] initWithNibName:@"TXSignInVC" bundle:nil];
        [self pushViewController:signInVC];
    }
    
}

@end
