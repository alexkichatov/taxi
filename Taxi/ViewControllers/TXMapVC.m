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

const NSString *SPACE_BAR = @" ";

@interface TXMapVC () <TXEventListener> {
    NSMutableArray *items;
}

-(IBAction)search:(id)sender;
-(IBAction)keyTyped:(id)sender;

@end

@implementation TXMapVC {
    
}

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
	
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationMgr = [[CLLocationManager alloc] init];
        self.locationMgr.delegate = self;
        self.locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationMgr startUpdatingLocation];
    }
    
    self->items = [NSMutableArray new];
    
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
//    marker.title = @"Sydney";
//    marker.snippet = @"Australia";
//    marker.map = self.mapView_;
    
    self.mapView_.myLocationEnabled = YES;
    self.mapView_.settings.myLocationButton = YES;
    [self.mapView_ setDelegate:self];
    
  //  [self.mapView_ addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];

    CLLocationCoordinate2D currentPosition = self.mapView_.myLocation.coordinate;
    
    GMSCameraPosition* camera =
    [GMSCameraPosition cameraWithTarget: currentPosition zoom: 14];
    self.mapView_.camera = camera;
    self.mapView_.delegate=self;
    

    self.mapView_.myLocationEnabled = YES;
    
    self.mapView_.settings.myLocationButton = YES;
    
}

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

-(void) addMarker:(CLLocationCoordinate2D) position {

    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.icon = [GMSMarker markerImageWithColor:[UIColor yellowColor]];
    marker.title = @"Hello World";
    marker.map = self.mapView_;

}

-(void) searchLocation {
   
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *location = [manager location];
    [self.mapView_ animateToLocation:location.coordinate];
    [self.locationMgr stopUpdatingLocation];
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


-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation {
    
    CLLocation *location = [manager location];
    [self.mapView_ animateToLocation:location.coordinate];
    
}

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

- (IBAction)zoomIn:(id)sender {

    
    
    //    float spanX = 0.0001;
//    float spanY = 0.0001;
//    MKCoordinateRegion region;
//    region.center.latitude = self.mapView.userLocation.coordinate.latitude;
//    region.center.longitude = self.mapView.userLocation.coordinate.longitude;
//    region.span.latitudeDelta = spanX;
//    region.span.longitudeDelta = spanY;
//    [self.mapView_ setRegion:region animated:YES];
}

- (IBAction)zoomOut:(id)sender {
//    float spanX = 2.0;
//    float spanY = 2.0;
//    MKCoordinateRegion region;
//    region.center.latitude = self.mapView.userLocation.coordinate.latitude;
//    region.center.longitude = self.mapView.userLocation.coordinate.longitude;
//    region.span.latitudeDelta = spanX;
//    region.span.longitudeDelta = spanY;
//    [self.mapView setRegion:region animated:YES];
}

-(void)onEvent:(TXEvent *)event eventParams:(id)subscriptionParams {
    
    NSArray *predictions = [event.getEventProperties objectForKey:TXEvents.Params.GOOGLEOBJECT];

    [self->items removeAllObjects];
    for (TXPrediction *pred in predictions) {
        [self->items addObject:pred.description];
    }
    
    //    NSDictionary *latLong = [[result objectForKey:@"geometry"] objectForKey:@"location"];

    /*
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[latLong objectForKey:@"lat"] doubleValue], [[latLong objectForKey:@"lng"] doubleValue]);
    
    [self addMarker:coord];
    
    CLLocation *location = [self.locationMgr location];

    //https://maps.googleapis.com/maps/api/directions/json?origin=41.725081032960752,44.764101696087813&destination=41.731533,44.8000461&sensor=false&key=AIzaSyA-mIDdBQDMjxoQ59UOpYnyqa0ogk9m7-M
    
    NSString *directionsAPIURL = [NSString stringWithFormat:@"origin=%f,%f&destination=%f,%f&sensor=false&key=%@", location.coordinate.latitude, location.coordinate.longitude, [[latLong objectForKey:@"lat"] doubleValue], [[latLong objectForKey:@"lng"] doubleValue], @"AIzaSyA-mIDdBQDMjxoQ59UOpYnyqa0ogk9m7-M" ];
    
    TXRequestObj *request = [TXRequestObj create:@"Directions" urlParams:directionsAPIURL listener:nil];
    
    TXSyncResponseDescriptor *desc = [[TXHttpRequestManager instance] sendSyncRequest:request];
    
    NSArray *routes = [(NSDictionary*)desc.source objectForKey:@"routes"];
    
    NSArray *legs = [[routes objectAtIndex:0] objectForKey:@"legs"];
    NSArray *steps = [[legs objectAtIndex:0] objectForKey:@"steps"];
    [self.mapView_ clear];
    
    for (NSDictionary *step in steps) {

        NSDictionary *polyline_ = [step objectForKey:@"polyline"];
        
        NSString *encodedStr = [polyline_ objectForKey:@"points"];
        
        GMSPolyline *polyline = [TXGoogleAPIUtil polylineWithEncodedString:encodedStr];
        polyline.strokeColor = [UIColor blueColor];
        polyline.strokeWidth = 4;
        polyline.map = self.mapView_;
        
    }
    
    */
    
    [self.tableView reloadData];
}

-(void)search:(id)sender {
    
    TXGoogleRequestManager *googleUtil = [[TXGoogleRequestManager alloc] init];
    [googleUtil addEventListener:self forEvent:TXEvents.GOOGLEREQUESTCOMPLETED eventParams:nil];
    
    [googleUtil sendPlaceTextSearchAsync:self.txtSearch.text sensor:YES optional:nil];
    
}

-(void)keyTyped:(id)sender {
    
    UITextField *field = (UITextField *) sender;
    NSString *typedText = field.text;
    int length = typedText.length;
    char lastChar = [typedText characterAtIndex:length - 1];
    
    
    if(lastChar == ' ' || isdigit(lastChar)) {
        
        TXGoogleRequestManager *googleUtil = [[TXGoogleRequestManager alloc] init];
        [googleUtil addEventListener:self forEvent:@"onGoogleRequestCompleted" eventParams:nil];
        
        [googleUtil sendPlaceAutocompleteAsync:field.text sensor:YES optional:nil];
    }
    
}

@end
