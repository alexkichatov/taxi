//
//  TXMapVC.m
//  Taxi
//
//  Created by Irakli Vashakidze on 3/15/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

/*
 * Tbilisi
 * 
 * Uznadze
 * latitude = 41.710639
 * longtitude = 44.793645
 *
 * Pavlovi
 * latitude = 41.7240013
 * longitude = 44.74367499999994
 */

#import "TXMapVC.h"

@interface TXMapVC () {
    CLLocationManager *locationMgr;
}

@end

@implementation TXMapVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;

    CLLocationCoordinate2D centerCoord = {self.mapView.userLocation.location.coordinate.latitude, self.mapView.userLocation.location.coordinate.longitude};
    [self.mapView setCenterCoordinate:centerCoord animated:TRUE]; //nothing happens, as latitude and longitude = 0.000000
    
    if (nil == self->locationMgr) {
        self->locationMgr = [[CLLocationManager alloc] init];
    }
    
    self->locationMgr.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self->locationMgr.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    self->locationMgr.delegate = self; //add as suggested
    [self->locationMgr startUpdatingLocation];
    
    NSLog(@"using LocationManager:current location latitude = %f, longtitude = %f", self->locationMgr.location.coordinate.latitude, self->locationMgr.location.coordinate.longitude);

    [self.mapView setCenterCoordinate:centerCoord animated:TRUE];

}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *location = [manager location];
    
    float latitude = location.coordinate.latitude;
    float longitude = location.coordinate.longitude;
    
    MKCoordinateRegion region;
    region.center.latitude = latitude;
    region.center.longitude = longitude;
    [self.mapView setRegion:region animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //self.mapView.centerCoordinate = userLocation.location.coordinate;
    
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance([userLocation coordinate], 100000, 100000);
    [self.mapView setRegion:region];
}

- (IBAction)zoomIn:(id)sender {
    float spanX = 0.0001;
    float spanY = 0.0001;
    MKCoordinateRegion region;
    region.center.latitude = self.mapView.userLocation.coordinate.latitude;
    region.center.longitude = self.mapView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)zoomOut:(id)sender {
    float spanX = 2.0;
    float spanY = 2.0;
    MKCoordinateRegion region;
    region.center.latitude = self.mapView.userLocation.coordinate.latitude;
    region.center.longitude = self.mapView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:YES];
}

@end
