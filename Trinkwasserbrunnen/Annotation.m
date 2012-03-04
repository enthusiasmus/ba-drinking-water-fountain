//
//  Annotation.m
//  AquaJuvavum
//
//  Created by N. Buchegger, L. Wanko, B. Huber.
//  Copyright (c) 2012 FH Salzburg. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation
@synthesize title, coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}
- (id)initWithDictionary:(NSDictionary *) dict {
    self = [super init];
    if (self != nil) {
        title = [dict objectForKey:@"name"];
        coordinate.latitude = [[dict objectForKey:@"latitude"] doubleValue];
        coordinate.longitude = [[dict objectForKey:@"longitude"] doubleValue];
    }
    return self;
}
@end