//
//  Photo+Flickr.m
//  TopPlaces
//
//  Created by Hartman on 8/11/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Place+Create.h"
#import "SearchTag+Create.h"

@implementation Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)flickrInfo
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [flickrInfo objectForKey:FLICKR_PHOTO_ID]];

    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];

    if (!matches || ([matches count] > 1)) {
        // handle error
    }
    else if ([matches count] == 0) {
        NSLog(@"Add new Photo: %@", flickrInfo);
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.unique = [flickrInfo objectForKey:FLICKR_PHOTO_ID];
        photo.title = [flickrInfo objectForKey:FLICKR_PHOTO_TITLE];
        photo.imageURL = [[FlickrFetcher urlForPhoto:flickrInfo format:FlickrPhotoFormatLarge] absoluteString];
        photo.whereTaken = [Place placeWithName:[flickrInfo valueForKeyPath:FLICKR_PHOTO_PLACE_NAME] inManagedObjectContext:context];
        NSArray *tags = [[flickrInfo valueForKeyPath:FLICKR_TAGS] componentsSeparatedByString:@" "];
        for (NSString *tag in tags) {
            SearchTag *searchTag = [SearchTag searchTagWithName:tag inManagedContext:context];
            if (searchTag) [photo addTagsObject:searchTag];
        }
    }
    else {
        photo = [matches lastObject];
    }

    return photo;

}
@end
