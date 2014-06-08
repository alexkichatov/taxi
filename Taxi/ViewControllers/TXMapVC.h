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
#import "MLPAutoCompleteTextField.h"

@interface TXMapVC : TXRootVC<CLLocationManagerDelegate, GMSMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MLPAutoCompleteTextFieldDataSource, MLPAutoCompleteTextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet GMSMapView *mapView_;
@property (nonatomic, strong) IBOutlet UITextField *txtSearch;
@property (nonatomic, retain) CLLocationManager *locationMgr;
@property (nonatomic, strong) IBOutlet MLPAutoCompleteTextField *autoCompleteTextField;
@property (strong, nonatomic) NSArray *countryObjects;

//Set this to true to prevent auto complete terms from returning instantly.
@property (assign) BOOL simulateLatency;

//Set this to true to return an array of autocomplete objects to the autocomplete textfield instead of strings.
//The objects returned respond to the MLPAutoCompletionObject protocol.

- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;

@end
