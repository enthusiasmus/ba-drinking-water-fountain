//
//  ViewController.h
//  Trinkwasserbrunnen
//
//  Created by Mahmood1 on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "JSON/SBJson.h"
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
    
     AddressAnnotation *addAnnotation;

    IBOutlet UIBarButtonItem *mapTypeStandard;
    IBOutlet UIBarButtonItem *mapTypeSatellite;
    IBOutlet UIBarButtonItem *mapTypeHybrid;
    
    IBOutlet UIBarButtonItem *mapType;
    IBOutlet UIBarButtonItem *userPosition;
    
    IBOutlet UIToolbar *mapTypeBar;
    IBOutlet UIToolbar *optionBar;
    
    IBOutlet UIView *searchField;
    IBOutlet UITextField *userLocationInput;
    IBOutlet UINavigationItem *searchHeadline;
    
    NSMutableDictionary* allData;
    NSMutableDictionary* nameData;
    
    IBOutlet UITabBar *tabBar;
    
    NSMutableData* responseData;
    MKPolyline* currentRoute;
    MKMapRect currentMapRect;
    MKPolylineView* polylineOverLayerView;
}

-(IBAction)showMapTypeBar;
-(IBAction)showSearchField : (int)buttonId;
-(IBAction)changeMapType:(id)sender;
-(IBAction)showUserLocation;
-(IBAction) showRoute: (NSString*) start andDestination: (NSString*) destination andMode: (NSString*) mode;
-(void)zoomAndSetCenter: (float)zoomLevel andLocation: (CLLocationCoordinate2D) location;
-(void)setActiveMapButton : (UIBarButtonItem *) activeButton andInactiveButton1 : (UIBarButtonItem *) inactiveButton1 andInactiveButton2 : (UIBarButtonItem *) inactiveButton2;
-(IBAction) setMarkers;
-(NSMutableArray *)decodePolyline: (NSMutableString *)encoded;
-(void)createPolyline: (NSMutableArray *)allpoints;
// -(BOOL) textFieldShouldReturn:(UITextField *)textField;

@end
