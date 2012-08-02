//
//  FlickrPhotoAnnotation.m
//  TopPlaces
//
//  Created by Hartman on 8/2/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "FlickrPhotoAnnotation.h"
#import "Flickr/FlickrFetcher.h"

@implementation FlickrPhotoAnnotation 

@synthesize photo = _photo;

+ (FlickrPhotoAnnotation *) annotationForPhoto:(NSDictionary *)photo
{
    FlickrPhotoAnnotation *annotation = [[FlickrPhotoAnnotation alloc] init];
    annotation.photo = photo;
    return annotation;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationDegrees latitude = [[self.photo valueForKeyPath:FLICKR_LATITUDE] doubleValue];
    CLLocationDegrees longitude = [[self.photo valueForKeyPath:FLICKR_LONGITUDE] doubleValue];
    return CLLocationCoordinate2DMake(latitude, longitude);
}

- (NSString *)title
{
    return [self.photo valueForKeyPath:FLICKR_PHOTO_TITLE];
}

- (NSString *)subtitle
{
    return [self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}

@end
