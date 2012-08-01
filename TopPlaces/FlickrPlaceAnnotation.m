//
//  FlickrPlaceAnnotation.m
//  TopPlaces
//
//  Created by Hartman on 7/31/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "FlickrPlaceAnnotation.h"
#import "FlickrFetcher.h"
#import <CoreLocation/CoreLocation.h>

@implementation FlickrPlaceAnnotation
@synthesize place = _place;

+ (FlickrPlaceAnnotation *) annotationForPlace:(NSDictionary *)place
{
    FlickrPlaceAnnotation *annotation = [[FlickrPlaceAnnotation alloc] init];
    annotation.place = place;
    return annotation;
}

#pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
    CLLocationDegrees latitude = [[self.place valueForKeyPath:FLICKR_LATITUDE] doubleValue];
    CLLocationDegrees longitude = [[self.place valueForKeyPath:FLICKR_LONGITUDE] doubleValue];
    return CLLocationCoordinate2DMake(latitude, longitude);
}

- (NSString *)title
{
    return [self.place valueForKeyPath:FLICKR_PLACE_NAME];
}

@end
