//
//  TXViewController.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/19/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXViewController.h"

@interface TXViewController ()

@end

@implementation TXViewController

-(void) configure {
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configure];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate = userLocation.location.coordinate;
}



@end
