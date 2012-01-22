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
    [UIToolbar animateWithDuration:0.2 animations:^{[mapTypeBar setAlpha:!mapTypeBar.alpha];}];
    if (mapTypeBar.alpha == 0) {
        [tabBar setSelectedItem:nil];
    }
}
- (IBAction)showWellSearch : (int)buttonId {         
    [UIView animateWithDuration:0.2 animations:^{[wellSearch setAlpha:!wellSearch.alpha];}];
    if (wellSearch.alpha == 0) {
        [tabBar setSelectedItem:nil];
    }
    if (buttonId == 1) {
     wellSearchHeadline.title = @"Trinken";
     // TODO: nähesten Trinkwasserbrunnen anzeigen
     } else if (buttonId == 2) {
     wellSearchHeadline.title = @"Route";
     // TODO: Route zum nähesten Trinkwasserbrunnen anzeigen
     }
}

- (IBAction)changeMapType:(id)sender{     
    [self showMapTypeBar];

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
}

-(void)setActiveMapButton : (UIBarButtonItem *) activeButton andInactiveButton1 : (UIBarButtonItem *) inactiveButton1 andInactiveButton2 : (UIBarButtonItem *) inactiveButton2
{
    activeButton.tintColor = [UIColor blackColor];
    inactiveButton1.tintColor = [UIColor darkGrayColor];
    inactiveButton2.tintColor = [UIColor darkGrayColor];
    
}

- (IBAction)showUserLocation{
    if (!map.userLocation.location) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Ihre Position kann derzeit nicht gefunden werden!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
    //[self zoomAndSetCenter: 3 andLocation: map.userLocation.location.coordinate];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    // NSLog(@"item selected");
    
    UITabBarItem *tabBarItem = (UITabBarItem *)item;
    int tabBarIndex = (int)tabBarItem.tag;
    switch(tabBarIndex){
        case 0:
            [self showUserLocation];
            break;
        case 1:
            [self showWellSearch : 1];
            break;
        case 2:
            [self showWellSearch : 2];
            break;
        case 3:
            [self showMapTypeBar];
            break;
    }
}

-(IBAction) showRoute
{
    
}
- (void)viewDidLoad
{    
    [super viewDidLoad];
    mapTypeBar.alpha = 0;
    wellSearch.alpha = 0;

    CLLocationCoordinate2D startLocation;
    startLocation.latitude = 47.45966555;
    startLocation.longitude = 13.12042236;
    [self zoomAndSetCenter: 10.5 andLocation: startLocation];
    
    map.delegate = self;
    tabBar.delegate = self;
    
    [self setMarkers];
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

- (MKAnnotationView *) map:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>) annotation
{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    annView.pinColor = MKPinAnnotationColorGreen;
    annView.animatesDrop=TRUE;
    annView.canShowCallout = YES;
    annView.draggable = YES;
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
