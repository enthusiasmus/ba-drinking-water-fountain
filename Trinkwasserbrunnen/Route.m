//
//  Route.m
//  AquaJuvavum
//
//  Created by N. Buchegger, L. Wanko, B. Huber.
//  Copyright (c) 2012 FH Salzburg. All rights reserved.
//

#import "ViewController.h"
#import "Route.h"

@implementation Route

//encode the routes part of responsed json
+(NSMutableArray *)decodePolyline: (NSMutableString *)encodedStr {
    NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[encodedStr length]];  
    [encoded appendString:encodedStr];  
    NSInteger len = [encoded length];  
    NSInteger index = 0;  
    NSMutableArray *array = [[NSMutableArray alloc] init];  
    NSInteger lat=0;  
    NSInteger lng=0;  
    while (index < len) {  
        NSInteger b;  
        NSInteger shift = 0;  
        NSInteger result = 0;  
        do {  
            b = [encoded characterAtIndex:index++] - 63;  
            result |= (b & 0x1f) << shift;  
            shift += 5;  
        } while (b >= 0x20);  
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));  
        lat += dlat;  
        shift = 0;  
        result = 0;  
        do {  
            b = [encoded characterAtIndex:index++] - 63;  
            result |= (b & 0x1f) << shift;  
            shift += 5;  
        } while (b >= 0x20);  
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));  
        lng += dlng;  
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];  
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];  
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];  
        [array addObject:loc];  
    }  
    return array;  
}

+ (MKPolyline *) createPolyline: (NSMutableArray *)allpoints{   
    MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * allpoints.count);
    
    for(int idx = 0; idx < allpoints.count; idx++)
    {
        CLLocation *currentLoc = [allpoints objectAtIndex:idx];
        MKMapPoint point = MKMapPointForCoordinate(currentLoc.coordinate);
        pointArr[idx] = point;
    }
    MKPolyline* currentRoute = [MKPolyline polylineWithPoints:pointArr count:allpoints.count];
    
    return currentRoute;
}

+ (MKMapRect) createMapRect: (NSMutableArray *)allpoints{
    // while we create the route points, we will also be calculating the bounding box of our route
    // so we can easily zoom in on it.
    MKMapPoint northEastPoint;
    MKMapPoint southWestPoint;

    for(int idx = 0; idx < allpoints.count; idx++)
    {
        CLLocation *currentLoc = [allpoints objectAtIndex:idx];
        
        MKMapPoint point = MKMapPointForCoordinate(currentLoc.coordinate);
        
        // if it is the first point, just use them, since we have till now nothing to compare
        if (idx == 0) {
            northEastPoint = point;
            southWestPoint = point;
        }
        else
        {
            if (point.x > northEastPoint.x)
                northEastPoint.x = point.x;
            if (point.y > northEastPoint.y)
                northEastPoint.y = point.y;
            if (point.x < southWestPoint.x)
                southWestPoint.x = point.x;
            if (point.y < southWestPoint.y)
                southWestPoint.y = point.y;
        }
    }

    MKMapRect currentMapRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, northEastPoint.x - southWestPoint.x, northEastPoint.y - southWestPoint.y);

    return currentMapRect;
}
@end
