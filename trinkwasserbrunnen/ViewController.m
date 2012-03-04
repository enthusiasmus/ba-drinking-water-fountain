//
//  ViewController.m
//  AquaJuvavum
//
//  Created by N. Buchegger, L. Wanko, B. Huber.
//  Copyright (c) 2012 FH Salzburg. All rights reserved.
//

#import "ViewController.h"
@implementation ViewController

/*
 * User Interface functions
 */

- (void)backToMap:(UIBarButtonItem *)myButton
{
    // hides imprint
    [UIView animateWithDuration:0.3 animations:^{[imprintView setAlpha: 0];}];
    
    // hides route and drink incl. keyboard
    [UIView animateWithDuration:0.3 animations:^{[searchField setAlpha: 0];}];
    [userInput resignFirstResponder];
    
    // disable active state of actual tab bar item
    [tabBar setSelectedItem:nil];
}

- (IBAction)showMapTypeBar{   
    //set alpha of searchField 0 when mapTypeBar is enabled
    if (searchField.alpha != 0)
        [UIToolbar animateWithDuration:0.3 animations:^{[searchField setAlpha: 0];}];
    if (imprintView.alpha != 0)
        [UIView animateWithDuration:0.3 animations:^{[imprintView setAlpha: 0];}];
    
    [UIToolbar animateWithDuration:0.3 animations:^{[mapTypeBar setAlpha:!mapTypeBar.alpha];}];
    if (mapTypeBar.alpha == 0) {
        [tabBar setSelectedItem:nil];
    }
}

- (IBAction)showSearchField:(int)buttonId {     
    //set alpha of mapTypeBar 0 when searching for the next fontaint
    if (mapTypeBar.alpha != 0)
        [UIToolbar animateWithDuration:0.3 animations:^{[mapTypeBar setAlpha: 0];}];
    if (imprintView.alpha != 0)
        [UIView animateWithDuration:0.3 animations:^{[imprintView setAlpha: 0];}];
    
    [UIView animateWithDuration:0.3 animations:^{[searchField setAlpha:1];}];
    
    if (searchField.alpha == 0)
        [tabBar setSelectedItem:nil];
    
    if(buttonId == 1){
        searchHeadline.title = @"Trinken";
        userInput.returnKeyType = UIReturnKeyGo;
    }
    else if(buttonId == 2)
        searchHeadline.title = @"Route";
    
    userInput.text = [[NSString alloc] initWithFormat:@"%f,%f", currentLocation.latitude, currentLocation.longitude];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{   
    UITabBarItem *tabBarItem = (UITabBarItem *)item;
    int tabBarIndex = (int)tabBarItem.tag;
    switch(tabBarIndex){
        case 0:
            [self showUserLocation];
            break;
        case 1:
            [self showSearchField : 1];
            break;
        case 2:
            [self showSearchField : 2];
            break;
        case 3:
            [self showMapTypeBar];
            break;
        case 4:           
            [UIView animateWithDuration:0.3 animations:^{[imprintView setAlpha:!imprintView.alpha];}];
            if(imprintView.alpha == 0)
                [self->tabBar setSelectedItem:nil];
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // hide keyboard and search field after pressing the "route" button
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{[searchField setAlpha:0];}];
    
    NSString* start;
    NSString* destination;
    CLLocationCoordinate2D destinationCoords;
    NSArray* checkTextType = [textField.text componentsSeparatedByString:@","];  
    
    if([checkTextType count] == 2){
        if(CLLocationCoordinate2DIsValid(CLLocationCoordinate2DMake([[checkTextType objectAtIndex:0] floatValue],[[checkTextType objectAtIndex:1] floatValue]))){
            start = textField.text;
            destinationCoords = [Helper getNextAnnotation:currentLocation andPointsToCheck:fontains];
            destination = [[NSString alloc] initWithFormat:@"%f,%f", destinationCoords.latitude, destinationCoords.longitude];
        
            if(searchHeadline.title == @"Route"){
                [self showRoute: start andDestination: destination andMode: @"walking"];
            }
            else{
                [map removeOverlay: currentRoute];
                polylineOverLayerView = nil;
                [self zoomAndSetCenter:2 andLocation: destinationCoords];
            }
            NSLog(@"VALID!");
            return YES;
        }
    }
    NSLog(@"NOT VALID!");
    [self getForwardGecoding:textField.text andMode:1];
    return YES;
}

- (IBAction)changeMapType:(id)sender{        
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    int index = (int)button.tag;
    switch(index){
        case 0:
            map.mapType = MKMapTypeStandard;
            [self setActiveMapButton:mapTypeStandard andInactiveButton1:mapTypeSatellite andInactiveButton2:mapTypeHybrid];
            break;
        case 1:
            map.mapType = MKMapTypeSatellite;
            [self setActiveMapButton:mapTypeSatellite andInactiveButton1:mapTypeStandard andInactiveButton2:mapTypeHybrid];
            break;
        case 2:
            map.mapType = MKMapTypeHybrid;
            [self setActiveMapButton:mapTypeHybrid andInactiveButton1:mapTypeStandard andInactiveButton2:mapTypeSatellite];
            break;
    }
    
    //after selecting a maptype disable mapTypeBar again
    [self showMapTypeBar];
}

-(void)setActiveMapButton : (UIBarButtonItem *) activeButton andInactiveButton1 : (UIBarButtonItem *) inactiveButton1 andInactiveButton2 : (UIBarButtonItem *) inactiveButton2
{
    activeButton.tintColor = [UIColor blackColor];
    inactiveButton1.tintColor = [UIColor darkGrayColor];
    inactiveButton2.tintColor = [UIColor darkGrayColor];
}

- (IBAction)showUserLocation{
    //set alpha of mapTypeBar and 0 when getting the current user location
    if (mapTypeBar.alpha != 0)
        [UIToolbar animateWithDuration:0.3 animations:^{[mapTypeBar setAlpha: 0];}];
    if (searchField.alpha != 0)
        [UIToolbar animateWithDuration:0.3 animations:^{[searchField setAlpha: 0];}];
    if (imprintView.alpha != 0)
        [UIToolbar animateWithDuration:0.3 animations:^{[imprintView setAlpha: 0];}];
    
    if (!map.userLocation.location) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Ihre Position kann derzeit nicht gefunden werden!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tabBar setSelectedItem:nil];
		[alert show];
    } else {
        [self zoomAndSetCenter: 3 andLocation: map.userLocation.location.coordinate];
    }
}

/*
 * Helping functions for working with the map
 */

- (void)zoomAndSetCenter: (float)zoomLevel andLocation: (CLLocationCoordinate2D) location{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, zoomLevel*METERS_PER_MILE, zoomLevel*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [map regionThatFits:viewRegion];
    [map setRegion:adjustedRegion animated:YES];
    NSLog(@"%f", zoomLevel);
}

/*
 * Delegated functions
 */

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if(!gotFirstUserLocation){
        [self zoomAndSetCenter: 3 andLocation: map.userLocation.location.coordinate];
        gotFirstUserLocation = true;
    }
    currentLocation = map.userLocation.location.coordinate;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (tabBar.selectedItem.tag == 0){
        [tabBar setSelectedItem:nil];
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id )overlay
{
    MKOverlayView* overlayView = nil;
    if(overlay == currentRoute)
    {
        //if we have not yet created an overlay view for this overlay, create it now.
        if(nil == polylineOverLayerView){
            polylineOverLayerView = [[MKPolylineView alloc] initWithPolyline: currentRoute];
            polylineOverLayerView.lineWidth = polylineWidth;
            polylineOverLayerView.strokeColor = polylineColor;
        }
        overlayView = polylineOverLayerView;
    }
    
    return overlayView;
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{    
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[Annotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            
            // Add a detail disclosure button to the callout
            UIButton* rightButton = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self action:@selector(myShowDetailsMethod:)
                  forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = rightButton;
        }
        else
        {
            pinView.annotation = annotation;
        }
        
        pinView.image = [UIImage imageNamed:@"map-marker.png"];
        return pinView;
    }    
    return nil;
}

/*
 * Project auto added functions
 */

- (void)viewDidLoad
{    
    [super viewDidLoad];
    mapTypeBar.alpha = 0;
    searchField.alpha = 0;
    imprintView.alpha = 0;
    gotFirstUserLocation = false;
    
    CLLocationCoordinate2D startLocation;
    startLocation.latitude = 47.45966555;
    startLocation.longitude = 13.12042236;
    [self zoomAndSetCenter: 10.5 andLocation: startLocation];
    
    map.delegate = self;
    tabBar.delegate = self;
    userInput.delegate = self;
    
    //read fontains from plist
    NSDictionary *tmp = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fontains" ofType:@"plist"]];
	self->fontainsPlist = [NSArray arrayWithArray:[tmp objectForKey:@"Root"]];
	
    if (fontainsPlist) {
        int i=0;
        fontains = [[NSMutableArray alloc] init];
        for (NSDictionary *fontainDict in fontainsPlist) {
            NSLog(@"annotation%d",i);
            i++;
            
            Annotation *annotation = [[Annotation alloc] initWithDictionary:fontainDict];
            [map addAnnotation: annotation];
            
            CLLocation *addingFontain = [[CLLocation alloc] initWithLatitude: annotation.coordinate.latitude longitude: annotation.coordinate.longitude];
            [fontains addObject: addingFontain];
        }
    } else {
        NSLog(@"Fontains Plist does not exist");
    }
    
    routeBackButton = [[UIBarButtonItem alloc]
                       initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                       target:self
                       action:@selector(backToMap:)];
    
    searchHeadline.leftBarButtonItem = routeBackButton;
    searchHeadline.hidesBackButton = NO;
    
    
    backButton = [[UIBarButtonItem alloc]
                  initWithBarButtonSystemItem:UIBarButtonSystemItemReply	
                  target:self
                  action:@selector(backToMap:)];
    
    imprintHeadline.leftBarButtonItem = backButton;
    imprintHeadline.hidesBackButton = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
    
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }
    else {
        return NO;
    }
}

/*
 * Everything for getting a required route
 */

-(IBAction) showRoute: (NSString*) start andDestination: (NSString*) destination andMode: (NSString*) mode{
    responseData = [NSMutableData data];
    
    NSArray* checkStartText = [start componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" ,"]];
    NSString* convertedStart = [checkStartText objectAtIndex:0];
    
    if(([checkStartText count]) > 1){
        for(int i=1; i<[checkStartText count]; i++){
            convertedStart = [[NSString alloc] initWithFormat:@"%@%%20%@", convertedStart, [checkStartText objectAtIndex:i]];
        }
    }
    else
        convertedStart = start;
    
    NSString *urlBeginn = @"https://maps.googleapis.com/maps/api/directions/json?origin=";
    NSString *urlEnd = @"&units=metric&sensor=true";
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", urlBeginn, convertedStart, @"&destination=", destination, @"&mode=", mode, urlEnd];
    NSLog(@"%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"finished showROUTE");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
    NSLog(@"response");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
    NSLog(@"receive");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	responseData = nil;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Die Routenanfrage konnte nicht durchgeführt werden!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {    
    NSLog(@"complete");
    
    [map removeOverlay: currentRoute];
    polylineOverLayerView = nil;
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	responseData = nil;
    
    NSArray *routes = [(NSDictionary*)[responseString JSONValue] objectForKey:@"routes"];// grab the first route
    
    if (!routes || !routes.count){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Die Routenanfrage ergab keine Ergebnisse!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSDictionary *route = [routes objectAtIndex:0];
    NSDictionary *leg = [[route objectForKey:@"legs"] objectAtIndex:0];// grab the first leg
    NSArray *steps = [leg objectForKey:@"steps"];// grab the steps array
    
    NSMutableArray *allPoints = [[NSMutableArray alloc] initWithCapacity:0];
    // walk through the steps array and decode each polyline, adding it's cllocations to a mutable array.
    for(NSDictionary* step in steps) {
        NSDictionary *polyline = [step objectForKey:@"polyline"];
        NSMutableString *encodedVal = [polyline objectForKey:@"points"];
        NSArray *points = [Route decodePolyline:encodedVal];
        [allPoints addObjectsFromArray:points];
    }
    currentRoute = [Route createPolyline: allPoints];
    
    MKMapRect currentMapRect = [Route createMapRect: allPoints];
    [map setRegion:MKCoordinateRegionForMapRect(currentMapRect) animated:YES];

    polylineWidth = 5.0f;
    polylineColor = [UIColor colorWithRed:0.1f green:0.1f blue:1.0f alpha:0.5f];
    [map addOverlay: currentRoute];
    
    NSLog(@"route erstellt");
}

/*
 * Helper functions for geocoding
 */

- (CLLocationCoordinate2D)getForwardGecoding: (NSString*) location andMode:(int)mode{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    __block CLPlacemark *placemark;
    [geocoder geocodeAddressString:location completionHandler:^(NSArray *placemarks, NSError *error) {

        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else{        
            if ([placemarks count] > 0) {
                placemark = [placemarks objectAtIndex:0];
                NSLog(@"Latitude: %@", [[NSNumber numberWithDouble:placemark.location.coordinate.latitude] stringValue]);
                NSLog(@"Longitued: %@", [[NSNumber numberWithDouble:placemark.location.coordinate.longitude] stringValue]);
                
                if(mode == 1){
                    CLLocationCoordinate2D destinationCoords = [Helper getNextAnnotation: CLLocationCoordinate2DMake([[NSNumber numberWithDouble:placemark.location.coordinate.latitude] floatValue], [[NSNumber numberWithDouble:placemark.location.coordinate.longitude] floatValue]) andPointsToCheck:fontains];
                    
                    NSString* destination = [[NSString alloc] initWithFormat:@"%f,%f", destinationCoords.latitude, destinationCoords.longitude];
                    NSString* start = [NSString stringWithFormat:@"%@,AT", location];
                    
                    if(searchHeadline.title == @"Route"){
                        [self showRoute: start andDestination: destination andMode: @"walking"];
                    }
                    else{
                        [map removeOverlay: currentRoute];
                        polylineOverLayerView = nil;
                        [self zoomAndSetCenter:2 andLocation: destinationCoords];
                    }
                }
            }       
        }
    }];
    return CLLocationCoordinate2DMake([[NSNumber numberWithDouble:placemark.location.coordinate.latitude] floatValue], [[NSNumber numberWithDouble:placemark.location.coordinate.longitude] floatValue]);
}

- (NSString*)getReverseGecoding: (CLLocationCoordinate2D) location andMode:(int) mode{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *locLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    __block CLPlacemark *placemark;
    
    [geocoder reverseGeocodeLocation:locLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            if ([placemarks count] > 0) {
                placemark = [placemarks objectAtIndex:0];
                NSLog(@"%@", placemark.postalCode);
                NSLog(@"%@", placemark.locality);
                NSLog(@"%@", placemark.thoroughfare);
                NSLog(@"%@", placemark.subThoroughfare);
            }      
        }
    }];
    NSString *adress = [NSString stringWithFormat:@"%@ /%@ /%@ /%@", placemark.postalCode, placemark.locality, placemark.thoroughfare, placemark.subThoroughfare];
    return adress;
}

@end