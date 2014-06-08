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
#import "DEMOCustomAutoCompleteCell.h"
#import "DEMOCustomAutoCompleteObject.h"

const NSString *SPACE_BAR = @" ";

@interface TXMapVC () <TXEventListener> {
    NSMutableArray *items;
    TXGoogleRequestManager *googleReqMgr;
    NSString *country;
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
    
    //[self setSimulateLatency:YES]; //Uncomment to delay the return of autocomplete suggestions.
    //[self setTestWithAutoCompleteObjectsInsteadOfStrings:YES]; //Uncomment to return autocomplete objects instead of strings to the textfield.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideWithNotification:) name:UIKeyboardDidHideNotification object:nil];
    
//    [self.typeSwitch addTarget:self
//                        action:@selector(typeDidChange:)
//              forControlEvents:UIControlEventValueChanged];
    
    //Supported Styles:
    //[self.autocompleteTextField setBorderStyle:UITextBorderStyleBezel];
    //[self.autocompleteTextField setBorderStyle:UITextBorderStyleLine];
    //[self.autocompleteTextField setBorderStyle:UITextBorderStyleNone];
    [self.autoCompleteTextField setBorderStyle:UITextBorderStyleRoundedRect];
    
    //[self.autocompleteTextField setShowAutoCompleteTableWhenEditingBegins:YES];
    //[self.autocompleteTextField setAutoCompleteTableBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
    
    //You can use custom TableViewCell classes and nibs in the autocomplete tableview if you wish.
    //This is only supported in iOS 6.0, in iOS 5.0 you can set a custom NIB for the cell
    if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending) {
        [self.autoCompleteTextField registerAutoCompleteCellClass:[DEMOCustomAutoCompleteCell class]
                                           forCellReuseIdentifier:@"CustomCellId"];
    }
    else{
        //Turn off bold effects on iOS 5.0 as they are not supported and will result in an exception
        self.autoCompleteTextField.applyBoldEffectToAutoCompleteSuggestions = NO;
    }

    
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

-(void)search:(id)sender {
    
    TXRootVC* (^vc)() = ^(){
        
        TXRootVC *result = [self vcFromName:NSStringFromClass([TXSignInVC class])];
        
        return result;
    };
    
    [self pushViewControllerAndPopPrevious:vc completionBlock:nil];
    
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

// ==========================

- (void)typeDidChange:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex == 0){
        [self.autoCompleteTextField setAutoCompleteTableAppearsAsKeyboardAccessory:NO];
    } else {
        [self.autoCompleteTextField setAutoCompleteTableAppearsAsKeyboardAccessory:YES];
    }
    
}

- (void)keyboardDidHideWithNotification:(NSNotification *)aNotification
{
    [self.autoCompleteTextField setAutoCompleteTableViewHidden:NO];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - MLPAutoCompleteTextField DataSource


//example of asynchronous fetch:
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        if(self.simulateLatency){
            CGFloat seconds = arc4random_uniform(4)+arc4random_uniform(4); //normal distribution
            NSLog(@"sleeping fetch of completions for %f", seconds);
            sleep(seconds);
        }
        handler([self allCountries]);
    });
}

/*
 - (NSArray *)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
 {
 
 if(self.simulateLatency){
 CGFloat seconds = arc4random_uniform(4)+arc4random_uniform(4); //normal distribution
 NSLog(@"sleeping fetch of completions for %f", seconds);
 sleep(seconds);
 }
 
 NSArray *completions;
 if(self.testWithAutoCompleteObjectsInsteadOfStrings){
 completions = [self allCountryObjects];
 } else {
 completions = [self allCountries];
 }
 
 return completions;
 }
 */

- (NSArray *)allCountries
{
    NSArray *countries =
    @[
      @"Abkhazia",
      @"Afghanistan",
      @"Aland",
      @"Albania",
      @"Algeria",
      @"American Samoa",
      @"Andorra",
      @"Angola",
      @"Anguilla",
      @"Antarctica",
      @"Antigua & Barbuda",
      @"Argentina",
      @"Armenia",
      @"Aruba",
      @"Australia",
      @"Austria",
      @"Azerbaijan",
      @"Bahamas",
      @"Bahrain",
      @"Bangladesh",
      @"Barbados",
      @"Belarus",
      @"Belgium",
      @"Belize",
      @"Benin",
      @"Bermuda",
      @"Bhutan",
      @"Bolivia",
      @"Bosnia & Herzegovina",
      @"Botswana",
      @"Brazil",
      @"British Antarctic Territory",
      @"British Virgin Islands",
      @"Brunei",
      @"Bulgaria",
      @"Burkina Faso",
      @"Burundi",
      @"Cambodia",
      @"Cameroon",
      @"Canada",
      @"Cape Verde",
      @"Cayman Islands",
      @"Central African Republic",
      @"Chad",
      @"Chile",
      @"China",
      @"Christmas Island",
      @"Cocos Keeling Islands",
      @"Colombia",
      @"Commonwealth",
      @"Comoros",
      @"Cook Islands",
      @"Costa Rica",
      @"Cote d'Ivoire",
      @"Croatia",
      @"Cuba",
      @"Cyprus",
      @"Czech Republic",
      @"Democratic Republic of the Congo",
      @"Denmark",
      @"Djibouti",
      @"Dominica",
      @"Dominican Republic",
      @"East Timor",
      @"Ecuador",
      @"Egypt",
      @"El Salvador",
      @"England",
      @"Equatorial Guinea",
      @"Eritrea",
      @"Estonia",
      @"Ethiopia",
      @"European Union",
      @"Falkland Islands",
      @"Faroes",
      @"Fiji",
      @"Finland",
      @"France",
      @"Gabon",
      @"Gambia",
      @"Georgia",
      @"Germany",
      @"Ghana",
      @"Gibraltar",
      @"GoSquared",
      @"Greece",
      @"Greenland",
      @"Grenada",
      @"Guam",
      @"Guatemala",
      @"Guernsey",
      @"Guinea Bissau",
      @"Guinea",
      @"Guyana",
      @"Haiti",
      @"Honduras",
      @"Hong Kong",
      @"Hungary",
      @"Iceland",
      @"India",
      @"Indonesia",
      @"Iran",
      @"Iraq",
      @"Ireland",
      @"Isle of Man",
      @"Israel",
      @"Italy",
      @"Jamaica",
      @"Japan",
      @"Jersey",
      @"Jordan",
      @"Kazakhstan",
      @"Kenya",
      @"Kiribati",
      @"Kosovo",
      @"Kuwait",
      @"Kyrgyzstan",
      @"Laos",
      @"Latvia",
      @"Lebanon",
      @"Lesotho",
      @"Liberia",
      @"Libya",
      @"Liechtenstein",
      @"Lithuania",
      @"Luxembourg",
      @"Macau",
      @"Macedonia",
      @"Madagascar",
      @"Malawi",
      @"Malaysia",
      @"Maldives",
      @"Mali",
      @"Malta",
      @"Mars",
      @"Marshall Islands",
      @"Mauritania",
      @"Mauritius",
      @"Mayotte",
      @"Mexico",
      @"Micronesia",
      @"Moldova",
      @"Monaco",
      @"Mongolia",
      @"Montenegro",
      @"Montserrat",
      @"Morocco",
      @"Mozambique",
      @"Myanmar",
      @"Nagorno Karabakh",
      @"Namibia",
      @"NATO",
      @"Nauru",
      @"Nepal",
      @"Netherlands Antilles",
      @"Netherlands",
      @"New Caledonia",
      @"New Zealand",
      @"Nicaragua",
      @"Niger",
      @"Nigeria",
      @"Niue",
      @"Norfolk Island",
      @"North Korea",
      @"Northern Cyprus",
      @"Northern Mariana Islands",
      @"Norway",
      @"Olympics",
      @"Oman",
      @"Pakistan",
      @"Palau",
      @"Palestine",
      @"Panama",
      @"Papua New Guinea",
      @"Paraguay",
      @"Peru",
      @"Philippines",
      @"Pitcairn Islands",
      @"Poland",
      @"Portugal",
      @"Puerto Rico",
      @"Qatar",
      @"Red Cross",
      @"Republic of the Congo",
      @"Romania",
      @"Russia",
      @"Rwanda",
      @"Saint Barthelemy",
      @"Saint Helena",
      @"Saint Kitts & Nevis",
      @"Saint Lucia",
      @"Saint Vincent & the Grenadines",
      @"Samoa",
      @"San Marino",
      @"Sao Tome & Principe",
      @"Saudi Arabia",
      @"Scotland",
      @"Senegal",
      @"Serbia",
      @"Seychelles",
      @"Sierra Leone",
      @"Singapore",
      @"Slovakia",
      @"Slovenia",
      @"Solomon Islands",
      @"Somalia",
      @"Somaliland",
      @"South Africa",
      @"South Georgia & the South Sandwich Islands",
      @"South Korea",
      @"South Ossetia",
      @"South Sudan",
      @"Spain",
      @"Sri Lanka",
      @"Sudan",
      @"Suriname",
      @"Swaziland",
      @"Sweden",
      @"Switzerland",
      @"Syria",
      @"Taiwan",
      @"Tajikistan",
      @"Tanzania",
      @"Thailand",
      @"Togo",
      @"Tonga",
      @"Trinidad & Tobago",
      @"Tunisia",
      @"Turkey",
      @"Turkmenistan",
      @"Turks & Caicos Islands",
      @"Tuvalu",
      @"Uganda",
      @"Ukraine",
      @"United Arab Emirates",
      @"United Kingdom",
      @"United Nations",
      @"United States",
      @"Uruguay",
      @"US Virgin Islands",
      @"Uzbekistan",
      @"Vanuatu",
      @"Vatican City",
      @"Venezuela",
      @"Vietnam",
      @"Wales",
      @"Western Sahara",
      @"Yemen",
      @"Zambia",
      @"Zimbabwe"
      ];
    
    return countries;
}



#pragma mark - MLPAutoCompleteTextField Delegate


- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
          shouldConfigureCell:(UITableViewCell *)cell
       withAutoCompleteString:(NSString *)autocompleteString
         withAttributedString:(NSAttributedString *)boldedString
        forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject
            forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //This is your chance to customize an autocomplete tableview cell before it appears in the autocomplete tableview
    NSString *filename = [autocompleteString stringByAppendingString:@".png"];
    filename = [filename stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    filename = [filename stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
    [cell.imageView setImage:[UIImage imageNamed:filename]];
    
    return YES;
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
       withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject
            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedObject){
        NSLog(@"selected object from autocomplete menu %@ with string %@", selectedObject, [selectedObject autocompleteString]);
    } else {
        NSLog(@"selected string '%@' from autocomplete menu", selectedString);
    }
}



@end
