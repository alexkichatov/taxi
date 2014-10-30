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
#import "TXGoogleRequestManager.h"
#import "utils.h"
#import "TXHttpRequestManager.h"
#import "StrConsts.h"
#import "NSString+TXNSString.h"
#import "TXCallModel.h"
#import "TXSignInVC.h"
#import <AudioToolbox/AudioServices.h>

const NSString *SPACE_BAR = @" ";

@interface TXMapVC () <TXEventListener> {
    NSMutableArray *items;
    TXGoogleRequestManager *googleReqMgr;
    NSString *country;
    CLLocationCoordinate2D pickupCoordinate;
}

-(IBAction)search:(id)sender;
-(IBAction)keyTyped:(id)sender;
-(IBAction)editProfile:(id)sender;
-(IBAction)logout:(id)sender;
-(IBAction)selectDest:(id)sender;

@end

@implementation TXMapVC {
    
}

-(void)configure {
    [super configure];
    
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationMgr = [[CLLocationManager alloc] init];
        self.locationMgr.delegate = self;
        self.locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationMgr startUpdatingLocation];
        
    }
    
    self->items = [NSMutableArray new];
    self->googleReqMgr = [[TXGoogleRequestManager alloc] init];
    [self->googleReqMgr addEventListener:self forEvent:TXEvents.GOOGLE_PLACES_AUTOCOMP_REQ_COMPLETED eventParams:nil];
    [self->googleReqMgr addEventListener:self forEvent:TXEvents.GOOGLE_DIRECTIONS_REQ_COMPLETED eventParams:nil];
    
    self.mapView_.myLocationEnabled = YES;
    self.mapView_.settings.myLocationButton = YES;
    [self.mapView_ setDelegate:self];
    
    CLLocationCoordinate2D currentPosition = self.mapView_.myLocation.coordinate;
    
    GMSCameraPosition* camera =
    [GMSCameraPosition cameraWithTarget: currentPosition zoom: 14];
    self.mapView_.camera = camera;
    self.mapView_.delegate=self;
    
    
    self.mapView_.myLocationEnabled = YES;
    
    self.mapView_.settings.myLocationButton = YES;
    
    [self.btnSelectDest.layer setBorderWidth:0.7f];
    [self.btnSelectDest.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [self.mapView_ bringSubviewToFront:self.btnSelectDest];

}

#pragma mark - Actions

-(void)editProfile:(id)sender {
    
}

-(void)logout:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Do you really want to log out ?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Yes"])
    {
        NSLog(@"Log out");
    }
    else if([title isEqualToString:@"Cancel"])
    {
        NSLog(@"Stay in system");
        
    }
}

-(void)selectDest:(id)sender {
    
}


-(void)search:(id)sender {
    
//    TXRootVC* (^vc)() = ^(){
//        
//        TXRootVC *result = [self vcFromName:NSStringFromClass([TXSignInVC class])];
//        
//        return result;
//    };
    
    //[self pushViewControllerAndPopPrevious:vc completionBlock:nil];
    
    //  [self->googleReqMgr sendPlaceTextSearchAsync:self.txtSearch.text sensor:YES optional:nil];
    
}

-(void)keyTyped:(id)sender {
    
    UITextField *field = (UITextField *) sender;
    NSString *typedText = field.text;
    int length = typedText.length;
    char lastChar = [typedText characterAtIndex:length - 1];
    
    
    if(lastChar == ' ' || isdigit(lastChar)) {
        
        [self->googleReqMgr sendPlaceAutocompleteAsync:field.text sensor:YES optional:nil];
    }
    
}

#pragma mark - End of Actions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self->items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString * identifier = @"Cell";
    
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self->items[indexPath.row];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self->country = [[self->items objectAtIndex:indexPath.row] substringFromRightToCharacter:' '];
    
    [self->googleReqMgr sendDirectionsByCoordinatesAsync:41.725081032960752 startLongitude:44.764101696087813 endLocation:[self->items objectAtIndex:indexPath.row] sensor:YES optional:nil];
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[latLong objectForKey:@"lat"] doubleValue], [[latLong objectForKey:@"lng"] doubleValue]);
//    
//    [self addMarker:coord];
//
    
  //  CLLocation *location = [self.locationMgr location];
    
    //https://maps.googleapis.com/maps/api/directions/json?origin=41.725081032960752,44.764101696087813&destination=41.731533,44.8000461&sensor=false&key=AIzaSyA-mIDdBQDMjxoQ59UOpYnyqa0ogk9m7-M
//    
//    NSString *directionsAPIURL = [NSString stringWithFormat:@"origin=%f,%f&destination=%@&sensor=false&key=%@", location.coordinate.latitude, location.coordinate.longitude, [self->items objectAtIndex:indexPath.row], @"AIzaSyA-mIDdBQDMjxoQ59UOpYnyqa0ogk9m7-M" ];
//    
//    
    
//    
//
//    NSArray *routes = [(NSDictionary*)desc.source objectForKey:@"routes"];
//    
//    NSArray *legs = [[routes objectAtIndex:0] objectForKey:@"legs"];
//    NSArray *steps = [[legs objectAtIndex:0] objectForKey:@"steps"];
//    [self.mapView_ clear];
//    
//    for (NSDictionary *step in steps) {
//        
//        NSDictionary *polyline_ = [step objectForKey:@"polyline"];
//        
//        NSString *encodedStr = [polyline_ objectForKey:@"points"];
//        
//        GMSPolyline *polyline = [TXGoogleRequestManager polylineWithEncodedString:encodedStr];
//        polyline.strokeColor = [UIColor blueColor];
//        polyline.strokeWidth = 4;
//        polyline.map = self.mapView_;
//        
//    }
//
//    NSLog(@"%@", [[legs[0] objectForKey:@"distance"] objectForKey:@"text"]);
}

-(void) addMarker:(CLLocationCoordinate2D) position {

    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.icon = [UIImage imageNamed:@"marker.png"]; //[GMSMarker markerImageWithColor:[UIColor yellowColor]];
    marker.map = self.mapView_;
    marker.draggable = YES;
    marker.title = @"Touch to move";
}

-(void)mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void) mapView:(GMSMapView *)mapView didDragMarker:(GMSMarker *)marker
{
    self->pickupCoordinate = marker.position;
}

-(void) searchLocation {
   
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *location = [manager location];
    [self.mapView_ animateToLocation:location.coordinate];
    [self.locationMgr stopUpdatingLocation];
    
    self->pickupCoordinate = location.coordinate;
    [self addMarker:self->pickupCoordinate];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        NSLog(@"%.8f", currentLocation.coordinate.longitude);
        NSLog(@"%.8f", currentLocation.coordinate.latitude);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"myLocation"]) {
        CLLocation *location = [object myLocation];
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude
                                                                longitude:location.coordinate.longitude
                                                                     zoom:10
                                                                  bearing:30
                                                             viewingAngle:45];
        [self.mapView_ setCamera:camera];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Error while getting core location : %@",[error localizedFailureReason]);
    if ([error code] == kCLErrorDenied) {
        //you had denied
    }
    [manager stopUpdatingLocation];
}


//-(void)locationManager:(CLLocationManager *)manager
//   didUpdateToLocation:(CLLocation *)newLocation
//          fromLocation:(CLLocation *)oldLocation {
//    
//    CLLocation *location = [manager location];
//    [self.mapView_ animateToLocation:location.coordinate];
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //self.mapView.centerCoordinate = userLocation.location.coordinate;
    
  //  MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance([userLocation coordinate], 100000, 100000);
  //  [self.mapView setRegion:region];
}

-(void)onEvent:(TXEvent *)event eventParams:(id)subscriptionParams {
    
    if([event.name isEqualToString:TXEvents.GOOGLE_PLACES_AUTOCOMP_REQ_COMPLETED]) {
   
        NSArray *predictions = [event.getEventProperties objectForKey:TXEvents.Params.GOOGLEOBJECT];
        
        [self->items removeAllObjects];
        for (TXPrediction *pred in predictions) {
            [self->items addObject:pred.description];
        }
        
        [self.tableView reloadData];
        
    } else if ([event.name isEqualToString:TXEvents.GOOGLE_DIRECTIONS_REQ_COMPLETED]) {
     
        NSDictionary *obj = [event getEventProperty:TXEvents.Params.GOOGLEOBJECT];
        
        [[TXCallModel instance] requestChargeForCountry:self->country distance:[[obj objectForKey:@"distance"] longValue]];
        
    }
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
