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
#import "TXRootVC.h"

@interface TXMapVC : TXRootVC<CLLocationManagerDelegate, GMSMapViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet GMSMapView *mapView_;
@property (nonatomic, strong) IBOutlet UITextField *txtSearch;
@property (nonatomic, retain) CLLocationManager *locationMgr;

- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;

@end
