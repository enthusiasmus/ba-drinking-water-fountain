//
//  ViewController.m
//  Trinkwasserbrunnen
//
//  Created by Mahmood1 on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
@implementation AddressAnnotation
@synthesize coordinate;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c
{
    coordinate=c;
    NSLog(@"%f,%f",c.latitude,c.longitude);
    return self;
}

@end

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (IBAction)showMapTypeBar{   
    //set alpha of searchField 0 when mapTypeBar is enabled
    if (searchField.alpha != 0)
        [UIToolbar animateWithDuration:0.3 animations:^{[searchField setAlpha: 0];}];
    
    [UIToolbar animateWithDuration:0.3 animations:^{[mapTypeBar setAlpha:!mapTypeBar.alpha];}];
    if (mapTypeBar.alpha == 0) {
        [tabBar setSelectedItem:nil];
    }
}
- (IBAction)showSearchField:(int)buttonId {     
    //set alpha of mapTypeBar 0 when searching for the next fontaint
    if (mapTypeBar.alpha != 0)
        [UIToolbar animateWithDuration:0.3 animations:^{[mapTypeBar setAlpha: 0];}];
    
    [UIView animateWithDuration:0.3 animations:^{[searchField setAlpha:1];}];
    
    if (searchField.alpha == 0) {
        [tabBar setSelectedItem:nil];
    }
    
    if(buttonId == 1){
        searchHeadline.title = @"Trinken";
    }
    else if(buttonId == 2){
        searchHeadline.title = @"Route";
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // hide keyboard and search field after pressing the "route" button
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{[searchField setAlpha:0];}];
    
    // TODO: Funktionen, die Trinkwasserbrunnen bzw. Route anzeigen, hier aufrufen!
    
    [tabBar setSelectedItem:nil]; // FRAGE: wollen wir, dass hier der Aktiv-Status gleich verschwindet?
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
    
    if (!map.userLocation.location) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Ihre Position kann derzeit nicht gefunden werden!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tabBar setSelectedItem:nil];
		[alert show];
    } else {
        [self zoomAndSetCenter: 3 andLocation: map.userLocation.location.coordinate];
    }
}

- (void)zoomAndSetCenter: (float)zoomLevel andLocation: (CLLocationCoordinate2D) location{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, zoomLevel*METERS_PER_MILE, zoomLevel*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [map regionThatFits:viewRegion];
    [map setRegion:adjustedRegion animated:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if(!gotFirstUserLocation){
        [self zoomAndSetCenter: 3 andLocation: map.userLocation.location.coordinate];
        gotFirstUserLocation = true;
    }
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
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (tabBar.selectedItem.tag == 0){
        [tabBar setSelectedItem:nil];
    }
}

-(IBAction) showRoute
{
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", userLocationInput];
    NSString *locationString = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSLog(locationString);
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    mapTypeBar.alpha = 0;
    searchField.alpha = 0;
    gotFirstUserLocation = false;

    CLLocationCoordinate2D startLocation;
    startLocation.latitude = 47.45966555;
    startLocation.longitude = 13.12042236;
    [self zoomAndSetCenter: 10.5 andLocation: startLocation];
    
    map.delegate = self;
    tabBar.delegate = self;
    userLocationInput.delegate = self;
    
    [self showRoute: @"Salzburg" andDestination: @"Urstein Süd 1" andMode: @"walking"];
}

/* 
 * Make an JSON Quest on Google Directions, handle the data and display it
 */

-(IBAction) showRoute: (NSString*) start andDestination: (NSString*) destination andMode: (NSString*) mode{
    responseData = [NSMutableData data];
    
    NSString *urlBeginn = @"https://maps.googleapis.com/maps/api/directions/json?origin=";
    NSString *urlEnd = @"&units=metric&sensor=true";
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@", urlBeginn, start, @",AT&destination=", destination, @",AT&mode=", mode, urlEnd];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"showROUTE");
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
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	responseData = nil;
    
    NSArray *routes = [(NSDictionary*)[responseString JSONValue] objectForKey:@"routes"];// grab the first route
        
    if (!routes || !routes.count){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Die Routenanfrage ergab keine Ergebnisse!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSLog(@"%@", routes);
    
    NSDictionary *route = [routes objectAtIndex:0];
    NSDictionary *leg = [[route objectForKey:@"legs"] objectAtIndex:0];// grab the first leg
    NSArray *steps = [leg objectForKey:@"steps"];// grab the steps array
    
    NSMutableArray *allPoints = [[NSMutableArray alloc] initWithCapacity:0];
    // walk through the steps array and decode each polyline, adding it's cllocations to a mutable array.
    for(NSDictionary* step in steps) {
        NSDictionary *polyline = [step objectForKey:@"polyline"];
        NSMutableString *encodedVal = [polyline objectForKey:@"points"];
        NSArray *points = [self decodePolyline:encodedVal];
        [allPoints addObjectsFromArray:points];
    }
    
    [self createPolyline: allPoints];
    [map addOverlay: currentRoute];
}

//encode the routes part of responsed json
-(NSMutableArray *)decodePolyline: (NSMutableString *)encodedStr {
    NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[encodedStr length]];  
    [encoded appendString:encodedStr];  
    NSInteger len = [encoded length];  
    NSInteger index = 0;  
    NSMutableArray *array = [[NSMutableArray alloc] init];  
    NSInteger lat=0;  
    NSInteger lng=0;  
    while (index < len) {  
        NSInteger b;  
        NSInteger shift = 0;  
        NSInteger result = 0;  
        do {  
            b = [encoded characterAtIndex:index++] - 63;  
            result |= (b & 0x1f) << shift;  
            shift += 5;  
        } while (b >= 0x20);  
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));  
        lat += dlat;  
        shift = 0;  
        result = 0;  
        do {  
            b = [encoded characterAtIndex:index++] - 63;  
            result |= (b & 0x1f) << shift;  
            shift += 5;  
        } while (b >= 0x20);  
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));  
        lng += dlng;  
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];  
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];  
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];  
        [array addObject:loc];  
    }  
    return array;  
}

- (void) createPolyline: (NSMutableArray *)allpoints{
    // while we create the route points, we will also be calculating the bounding box of our route
    // so we can easily zoom in on it.
    MKMapPoint northEastPoint;
    MKMapPoint southWestPoint;
    
    MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * allpoints.count);
    
    for(int idx = 0; idx < allpoints.count; idx++)
    {
        CLLocation *currentLoc = [allpoints objectAtIndex:idx];
            
        MKMapPoint point = MKMapPointForCoordinate(currentLoc.coordinate);
        
        // if it is the first point, just use them, since we have till now nothing to compare
        if (idx == 0) {
            northEastPoint = point;
            southWestPoint = point;
        }
        else
        {
            if (point.x > northEastPoint.x)
                northEastPoint.x = point.x;
            if(point.y > northEastPoint.y)
                northEastPoint.y = point.y;
            if (point.x < southWestPoint.x)
                southWestPoint.x = point.x;
            if (point.y < southWestPoint.y)
                southWestPoint.y = point.y;
        }
        
        pointArr[idx] = point;
    }
    
    currentRoute = [MKPolyline polylineWithPoints:pointArr count:allpoints.count];
    currentMapRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, northEastPoint.x - southWestPoint.x, northEastPoint.y - southWestPoint.y);
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id )overlay
{
    MKOverlayView* overlayView = nil;
    if(overlay == currentRoute)
    {
        //if we have not yet created an overlay view for this overlay, create it now.
        if(nil == polylineOverLayerView){
            polylineOverLayerView = [[MKPolylineView alloc] initWithPolyline: currentRoute];
            polylineOverLayerView.fillColor = [UIColor blueColor];
            polylineOverLayerView.strokeColor = [UIColor redColor];
            polylineOverLayerView.lineWidth = 6;
        }
        overlayView = polylineOverLayerView;
    }
    
    return overlayView;
}

- (IBAction) setMarkers
{
    //ToDo: Mehrere Markers plazieren
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.2;
    span.longitudeDelta=0.2;
    
    CLLocationCoordinate2D location; 
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"Coordinates.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:plistPath])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Coordinates" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:plistPath error:&error];
    }
    
    allData = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    NSLog(@"Inhalt: %@", allData);
    
    nameData = [allData objectForKey:@"Brunnen1"];
    NSLog(@"Brunnen: %@", nameData);
    
    NSString *Latitude = [nameData objectForKey:@"Latitude"];
    NSString *Longitude = [nameData objectForKey:@"Longitude"];
    
    location.latitude = [Latitude doubleValue];//37.58492206;
    location.longitude = [Longitude doubleValue];//-122.32237816;
    region.span=span;
    region.center=location;
    
    if(addAnnotation != nil)
    {
        [map removeAnnotation:addAnnotation];
        addAnnotation = nil;
    }
    
    addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location];
    [map addAnnotation:addAnnotation];
    
    [map setRegion:region animated:TRUE];
    [map regionThatFits:region];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    ;
}

- (MKAnnotationView *) map:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>) annotation
{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    annView.pinColor = MKPinAnnotationColorGreen;
    annView.animatesDrop=TRUE;
    //annView.canShowCallout = YES;
    [annView setSelected:YES];
    [annView addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    annView.calloutOffset = CGPointMake(-5, 5);
    return annView;
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
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
