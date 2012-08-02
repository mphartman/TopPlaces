//
//  FlickrPhotoAnnotation.h
//  TopPlaces
//
//  Created by Hartman on 8/2/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlickrPhotoAnnotation : NSObject <MKAnnotation>

+ (FlickrPhotoAnnotation *) annotationForPhoto:(NSDictionary *)photo; // a Flickr photo

@property (nonatomic, strong) NSDictionary *photo;

@end
