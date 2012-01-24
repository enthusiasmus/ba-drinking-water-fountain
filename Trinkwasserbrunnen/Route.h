//
//  Route.h
//  AquaJuvavum
//
//  Created by N. Buchegger, L. Wanko, B. Huber.
//  Copyright (c) 2012 FH Salzburg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Route : NSObject

+(NSMutableArray *)decodePolyline: (NSMutableString *)encodedStr;
+(MKPolyline *)createPolyline: (NSMutableArray *)allpoints;
+(MKMapRect)createMapRect: (NSMutableArray *)allpoints;

@end
