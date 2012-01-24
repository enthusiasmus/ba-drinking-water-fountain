//
//  Helper.h
//  Trinkwasserbrunnen
//
//  Created by Mahmood1 on 1/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Helper : NSObject

+ (CLLocationCoordinate2D)getForwardGecoding: (NSString*) location;
+ (NSString*)getReverseGecoding: (CLLocationCoordinate2D) location;
+ (CLLocationCoordinate2D)getNextAnnotation: (CLLocationCoordinate2D)startLocation andPointsToCheck: (NSArray*) fontains;

@end
