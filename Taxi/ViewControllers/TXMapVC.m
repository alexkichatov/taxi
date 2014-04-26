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
#import "TXGoogleAPIUtil.h"
#import "taxiLib/utils.h"
#import "TXHttpRequestManager.h"
#import "TXConsts.h"

@interface TXMapVC () <TXEventListener> {

}

-(IBAction)search:(id)sender;

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
    
    NSDictionary *props = [event.getEventProperties objectForKey:@"JSON"];
    NSDictionary *result = [props objectForKey:@"results"][0];
    NSDictionary *latLong = [[result objectForKey:@"geometry"] objectForKey:@"location"];

    NSLog(@"%@", [latLong objectForKey:@"lat"]);
    NSLog(@"%@", [latLong objectForKey:@"lng"]);
    
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
        
        GMSPolyline *polyline = [self polylineWithEncodedString:encodedStr];
        polyline.strokeColor = [UIColor blueColor];
        polyline.strokeWidth = 4;
        polyline.map = self.mapView_;
        
    }
    
    
}

-(void)search:(id)sender {
    
    TXGoogleAPIUtil *googleUtil = [[TXGoogleAPIUtil alloc] init];
    [googleUtil addEventListener:self forEvent:@"onGoogleRequestCompleted" eventParams:nil];
    
    [googleUtil sendPlaceTextSearchRequest:self.txtSearch.text sensor:YES optional:nil];
    
}

- (GMSPolyline *)polylineWithEncodedString:(NSString *)encodedString {
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
    
    GMSMutablePath *path = [[GMSMutablePath alloc] init];
    
    int i;
    for (i = 0; i < coordIdx; i++)
    {
        [path addCoordinate:coords[i]];
    }
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    free(coords);
    
    return polyline;
}

@end
