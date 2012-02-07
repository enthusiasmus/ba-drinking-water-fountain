//
//  Annotation.h
//  AquaJuvavum
//
//  Created by N. Buchegger, L. Wanko, B. Huber.
//  Copyright (c) 2012 FH Salzburg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    UIImage *image;
    NSString *title;
}
@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;
- (id)initWithLocation:(CLLocationCoordinate2D)coord;
- (id)initWithDictionary:(NSDictionary *) dict;
@end