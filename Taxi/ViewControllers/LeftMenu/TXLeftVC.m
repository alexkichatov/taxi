//
//  TXLeftVC.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/19/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXLeftVC.h"
#import "TXSidePanelVC.h"

#import "UIViewController+TXSidePanel.h"
#import "TXRightVC.h"
#import "TXCenterVC.h"

@interface TXLeftVC () {
    NSMutableArray *items;
}

@end

@implementation TXLeftVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
    
    self->items = [NSMutableArray new];
    [self->items addObject:@"Item 1"];
    [self->items addObject:@"Item 2"];
    [self->items addObject:@"Item 3"];
    [self->items addObject:@"Item 4"];
    [self->items addObject:@"Item 5"];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self _changeCenterPanelTapped:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logout" ofType:@"png"]];
//    
//    CGFloat widthScale = 25 / image.size.width;
//    CGFloat heightScale = 25 / image.size.height;
//    ((UIImageView*)[cell viewWithTag:1]).transform = CGAffineTransformMakeScale(widthScale, heightScale);
    ((UIImageView*)[cell viewWithTag:1]).image = image;


    
    
    ((UILabel*)[cell viewWithTag:2]).text = [self->items objectAtIndex:indexPath.row];

    return cell;
    
}

#pragma mark - Button Actions

- (void)_changeCenterPanelTapped:(id)sender {
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[TXCenterVC alloc] init]];
}

@end
