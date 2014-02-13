//
//  TXViewController.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/19/14.
//  Copyright (c) 2014 99S. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TXViewController : UIViewController<MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
