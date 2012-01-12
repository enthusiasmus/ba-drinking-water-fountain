//
//  ViewController.m
//  Trinkwasserbrunnen
//
//  Created by Mahmood1 on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

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
    MKUserLocation *userLocation = map.userLocation;
    if (!userLocation.location) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Ihre Position kann derzeit nicht gefunden werden!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
        //userPosition.enabled = false;
    } else {
        map.centerCoordinate = userLocation.location.coordinate;
    }
}

- (void)viewDidLoad
{ 
    [super viewDidLoad];
    mapTypeBar.alpha = 0;	
    // Do any additional setup after loading the view, typically from a nib.
    CLLocationCoordinate2D startLocation;
    startLocation.latitude = 47.35371062;
    startLocation.longitude = 13.09570313;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(startLocation, 25*METERS_PER_MILE, 25*METERS_PER_MILE);
    
    MKCoordinateRegion adjustedRegion = [map regionThatFits:viewRegion];
    
    [map setRegion:adjustedRegion animated:YES];
    
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
