//
//  TXRightViewController.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/19/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXRightVC.h"
#import "TXSidePanelVC.h"

#import "UIViewController+TXSidePanel.h"

@interface TXRightVC ()

@end

@implementation TXRightVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor redColor];
    self.label.text = @"Right Panel";
    [self.label sizeToFit];
    self.hide.frame = CGRectMake(self.view.bounds.size.width - 220.0f, 70.0f, 200.0f, 40.0f);
    self.hide.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.show.frame = self.hide.frame;
    self.show.autoresizingMask = self.hide.autoresizingMask;
    
    self.removeRightPanel.hidden = YES;
    self.addRightPanel.hidden = YES;
    self.changeCenterPanel.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.label.center = CGPointMake(floorf((self.view.bounds.size.width - self.sidePanelController.rightVisibleWidth) + self.sidePanelController.rightVisibleWidth/2.0f), 25.0f);
}

@end
