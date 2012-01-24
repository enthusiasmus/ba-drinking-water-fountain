//
//  ViewController.h
//  AquaJuvavum
//
//  Created by N. Buchegger, L. Wanko, B. Huber.
//  Copyright (c) 2012 FH Salzburg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON/SBJson.h"
#import "Annotation.h"
#import "Route.h"

#define METERS_PER_MILE 1609.344

@interface AddressAnnotation : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
}
@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;
-(id)initWithLocation:(CLLocationCoordinate2D)coord;

@end

@interface ViewController : UIViewController <MKMapViewDelegate, UITabBarDelegate, UITextFieldDelegate>
{
    BOOL _doneInitialZoom;
    BOOL gotFirstUserLocation;
    
    IBOutlet MKMapView *map;
    
    //for map
    IBOutlet UIBarButtonItem *mapTypeStandard;
    IBOutlet UIBarButtonItem *mapTypeSatellite;
    IBOutlet UIBarButtonItem *mapTypeHybrid;
    IBOutlet UIBarButtonItem *mapType;
    IBOutlet UIBarButtonItem *userPosition;
    
    //for screen
    IBOutlet UIView *searchField;
    IBOutlet UITextField *userInput;
    IBOutlet UINavigationItem *searchHeadline;
    IBOutlet UITabBar *tabBar;
    IBOutlet UIToolbar *mapTypeBar;
    IBOutlet UIToolbar *optionBar;
    
    //for markers
    NSMutableDictionary* allData;
    NSMutableDictionary* nameData;
    
    //for route
    NSMutableData* responseData;
    MKPolyline* currentRoute;
}

-(IBAction)showMapTypeBar;
-(IBAction)showSearchField : (int)buttonId;
-(IBAction)changeMapType:(id)sender;
-(IBAction)showUserLocation;
-(void)zoomAndSetCenter: (float)zoomLevel andLocation: (CLLocationCoordinate2D) location;
-(void)setActiveMapButton : (UIBarButtonItem *) activeButton andInactiveButton1 : (UIBarButtonItem *) inactiveButton1 andInactiveButton2 : (UIBarButtonItem *) inactiveButton2;
-(IBAction) setMarkers;
- (CLLocationCoordinate2D)getNextAnnotation: (CLLocationCoordinate2D)startLocation andPointsToCheck: (NSMutableArray*) fontains;
- (NSString*)getReverseGecoding: (CLLocationCoordinate2D) location;
- (CLLocationCoordinate2D)getForwardGecoding: (NSString*) location;
-(IBAction)showRoute: (NSString*) start andDestination: (NSString*) destination andMode: (NSString*) mode;
@end
