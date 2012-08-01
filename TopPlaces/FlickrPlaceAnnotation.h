//
//  FlickrPlaceAnnotation.h
//  TopPlaces
//
//  Created by Hartman on 7/31/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlickrPlaceAnnotation : NSObject <MKAnnotation>

+ (FlickrPlaceAnnotation *) annotationForPlace:(NSDictionary *)place;

@property (nonatomic, strong) NSDictionary *place;
@end
