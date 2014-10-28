//
//  MenuViewController.h
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "TXBaseViewController.h"

@interface TXSettingsMenuItem : NSObject
    
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage  *image;
@property (nonatomic, strong) TXBaseViewController *vc;

+(id) create:(NSString *) title image:(NSString *) image viewController:(NSString *)vc;

@end

@interface MenuViewController : TXBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
