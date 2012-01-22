//
//  ViewController.h
//  Trinkwasserbrunnen
//
//  Created by Mahmood1 on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344

@interface AddressAnnotation : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
}
@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;
-(id)initWithLocation:(CLLocationCoordinate2D)coord;

@end

@interface ViewController : UIViewController <MKMapViewDelegate, UITabBarDelegate>
{
    BOOL _doneInitialZoom;
    
    IBOutlet MKMapView *map;
    
     AddressAnnotation *addAnnotation;

    IBOutlet UIBarButtonItem *mapTypeStandard;
    IBOutlet UIBarButtonItem *mapTypeSatellite;
    IBOutlet UIBarButtonItem *mapTypeHybrid;
    
    IBOutlet UIBarButtonItem *mapType;
    IBOutlet UIBarButtonItem *userPosition;
    
    IBOutlet UIToolbar *mapTypeBar;
    IBOutlet UIToolbar *optionBar;
    
    IBOutlet UIView *wellSearch;
    IBOutlet UITextField *userLocationInput;
    IBOutlet UINavigationItem *wellSearchHeadline;
    
    NSMutableDictionary* allData;
    NSMutableDictionary* nameData;
    
    IBOutlet UITabBarItem *testTabBarItem;
    IBOutlet UITabBar *tabBar;
}

-(IBAction)showMapTypeBar;
-(IBAction)showWellSearch : (int)buttonId;
-(IBAction)changeMapType:(id)sender;
-(IBAction)showUserLocation;
-(IBAction)showRoute;
-(void)zoomAndSetCenter: (float)zoomLevel andLocation: (CLLocationCoordinate2D) location;
-(void)setActiveMapButton : (UIBarButtonItem *) activeButton andInactiveButton1 : (UIBarButtonItem *) inactiveButton1 andInactiveButton2 : (UIBarButtonItem *) inactiveButton2;
- (IBAction) setMarkers;    

@end
