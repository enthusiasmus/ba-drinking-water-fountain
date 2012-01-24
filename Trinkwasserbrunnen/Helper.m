//
//  Helper.m
//  Trinkwasserbrunnen
//
//  Created by Mahmood1 on 1/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (CLLocationCoordinate2D)getForwardGecoding: (NSString*) location{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    __block CLPlacemark *placemark;
    [geocoder geocodeAddressString:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        } else {        
            if ([placemarks count] > 0) {
                placemark = [placemarks objectAtIndex:0];
                NSLog(@"Latitude: %@", [[NSNumber numberWithDouble:placemark.location.coordinate.latitude] stringValue]);
                NSLog(@"Longitued: %@", [[NSNumber numberWithDouble:placemark.location.coordinate.longitude] stringValue]);
                
            }       
        }
    }];
    return CLLocationCoordinate2DMake([[NSNumber numberWithDouble:placemark.location.coordinate.latitude] floatValue], [[NSNumber numberWithDouble:placemark.location.coordinate.longitude] floatValue]);
}

+ (NSString*)getReverseGecoding: (CLLocationCoordinate2D) location{
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

+ (CLLocationCoordinate2D)getNextAnnotation: (CLLocationCoordinate2D)startLocation andPointsToCheck: (NSArray*) fontains{
    CLLocation *startLoc = [[CLLocation alloc] initWithLatitude:startLocation.latitude longitude:startLocation.longitude]; 
    
    NSLog(@"%@", fontains);
    
    if(!fontains || !fontains.count)
        return CLLocationCoordinate2DMake(0, 0);
    
    CLLocation *nearestFontain = [fontains objectAtIndex:0];
    for(int x=0; x<fontains.count; x++){
        if([startLoc distanceFromLocation:[fontains objectAtIndex:x]] > [startLoc distanceFromLocation:nearestFontain])
            nearestFontain = [fontains objectAtIndex:x];
    }
    
    NSLog(@"%@", nearestFontain);
    
    return CLLocationCoordinate2DMake(nearestFontain.coordinate.latitude, nearestFontain.coordinate.longitude);
}

@end
