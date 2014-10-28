//
//  TXMapVC.h
//  Taxi
//
//  Created by Irakli Vashakidze on 3/15/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "TXBaseViewController.h"

@interface TXMapVC : TXBaseViewController<CLLocationManagerDelegate, GMSMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet GMSMapView *mapView_;
@property (nonatomic, strong) IBOutlet UITextField *txtSearch;
@property (nonatomic, retain) CLLocationManager *locationMgr;
@property (nonatomic, strong) IBOutlet UITextField *autoCompleteTextField;
@property (nonatomic, retain) IBOutlet UIBarButtonItem  *btnProfile;
@property (nonatomic, retain) IBOutlet UIBarButtonItem  *btnLogOut;
@property (nonatomic, retain) IBOutlet UIButton         *btnSelectDest;
@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;

@property (strong, nonatomic) NSArray *countryObjects;

@end
