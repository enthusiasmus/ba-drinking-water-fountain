//
//  Route.h
//  AquaJuvavum
//
//  Created by N. Buchegger, L. Wanko, B. Huber.
//  Copyright (c) 2012 FH Salzburg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Route : NSObject {
    MKMapRect currentMapRect;
    MKPolyline* currentRoute;
    MKPolylineView* polylineOverLayerView;
}


+(NSMutableArray *)decodePolyline: (NSMutableString *)encoded;
+(MKPolyline *)createPolyline: (NSMutableArray *)allpoints;
+(MKMapRect)createMapRect: (NSMutableArray *)allpoints;

@end
