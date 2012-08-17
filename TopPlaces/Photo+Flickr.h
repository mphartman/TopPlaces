//
//  Photo+Flickr.h
//  TopPlaces
//
//  Created by Hartman on 8/11/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)flickrInfo
        inManagedObjectContext:(NSManagedObjectContext *)context;

@end
