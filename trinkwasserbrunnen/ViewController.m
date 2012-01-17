//
//  ViewController.m
//  Trinkwasserbrunnen
//
//  Created by Mahmood1 on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
//@synthesize runs, version;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (IBAction)showMapTypeBar{         
    [UIToolbar animateWithDuration:0.2 animations:^{[mapTypeBar setAlpha:!mapTypeBar.alpha];}];
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
    activeButton.tintColor = [UIColor darkGrayColor];
    inactiveButton1.tintColor = [UIColor lightGrayColor];
    inactiveButton2.tintColor = [UIColor lightGrayColor];
    
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
    [self zoomAndSetCenter: 3 andLocation: map.userLocation.location.coordinate];
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    mapTypeBar.alpha = 0;	

    CLLocationCoordinate2D startLocation;
    startLocation.latitude = 47.45966555;
    startLocation.longitude = 13.12042236;
    [self zoomAndSetCenter: 47.5 andLocation: startLocation];
    
    map.delegate = self;
    
   /* NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"Coordinates" ofType:@"plist"];
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSDictionary * temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    NSString *Latitude = [temp objectForKey:@"Latitude"];
    NSString *ongitude = [temp objectForKey:@"Longitude"];
   */
    
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
    
    allData = [NSMutableDictionary dictionaryWithContentsOfFile: plistPath];
    NSLog(@"Inhalt: %@", allData);
    
    [version setText: [allData objectForKey:@"Version"]];
    int starts = [[allData objectForKey:@"Runs"] intValue];
    starts ++;
    [runs setText:
     [NSString stringWithFormat:@"%i", starts]];
    
    [allData setObject:[NSNumber numberWithInt:starts] forKey:@"Runs"];
    [allData writeToFile:plistPath atomically:YES];
    
    allData = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    NSLog(@"Inhalt: %@", allData);
    
    nameData = [allData objectForKey:@"Brunnen"];
    NSLog(@"nameData: %@", nameData);
    
    //[name setText: [nameData objectForKey:@"Longitude";]];
   // [instrument set Text: [nameData objectForKey:@"Latitude"]];
    NSString *Latitude = [nameData objectForKey:@"Latitude"];
    NSString *L            ongitude = [nameData objectForKey:@"Longitude"];
    
    
    // Plist einlesen
    //[super viewDidLoad];
    /*NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"]; NSLog(@"Pfad: %@",plistPath);
    allData = [NSMutableDictionary dictionaryWithContentsOfFile: plistPath]; NSLog(@"Inhalt: %@", allData);
    // UI Ausgabe
    [version setText:[allData objectForKey:@"Version";]];
    int starts = [[allData objectForKey:@"Runs"] intValue]; starts ++;
    [runs setText: [NSString stringWithFormat:@"%i",starts;]];
    // Neue Runs-Zahl in Plist schreiben
    [allData setObject:[NSNumber numberWithInt:starts] forKey:@"Runs"]; [allData writeToFile:plistPath atomically:YES];
    // Was steht jetzt in der Plist?
    allData = [NSMutableDictionary dictionaryWithContentsOfFile: plistPath]; NSLog(@"Inhalt: %@", allData);
    // Sub-Dictionary aus Plist laden
    nameData = [allData objectForKey:@"Musician"]; NSLog(@"nameData: %@", nameData);
    // UI Ausgabe von nameData
    [name setText:[nameData objectForKey:@"Name";]];
    [instrument setText: [nameData objectForKey:@"Instrument";]];
}  

-(void) submitButton {
    // Plist einlesen
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"]; allData = [NSMutableDictionary dictionaryWithContentsOfFile: plistPath];
    nameData = [allData objectForKey:@"Musician"];
    // Veränderten Musician-Eintrag in Plist schreiben
    [nameData setValue:[name text] forKey:@"Name";];
    [nameData setValue:[instrument text] forKey:@"Instrument"]; [allData setObject:nameData forKey:@"Musician"];
    [allData writeToFile:plistPath atomically:YES];
}*/
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
