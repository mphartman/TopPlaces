//
//  FlickrPhotoDetailViewController.m
//  TopPlaces
//
//  Created by Hartman on 8/17/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "FlickrPhotoDetailViewController.h"
#import "FlickrFetcher.h"

@interface FlickrPhotoDetailViewController ()

@end

@implementation FlickrPhotoDetailViewController

@synthesize photoDetails = _photoDetails;

- (void)addPhotoToRecents
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recents = [[prefs objectForKey:@"TopPlaces.RecentPhotos"] mutableCopy];
    if (!recents) {
        recents = [NSMutableArray array];
    }
    
    // add this photo to the top of list of recents, avoiding adding duplicates based on Photo ID
     BOOL found = NO;
     NSString *photoId = [self.photoDetails valueForKeyPath:FLICKR_PHOTO_ID];
     for (NSDictionary *recentPhoto in recents) {
         if ([photoId isEqualToString:[recentPhoto valueForKeyPath:FLICKR_PHOTO_ID]]) {
             found = YES;
             break;
         }
     }
     if (!found && self.photoDetails) {
         [recents insertObject:self.photoDetails atIndex:0];
     }
     
     [prefs setObject:recents forKey:@"TopPlaces.RecentPhotos"];
     [prefs synchronize];
     
}

- (void)setPhotoDetails:(NSDictionary *)photoDetails
{
    if (_photoDetails != photoDetails) {
        _photoDetails = photoDetails;
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("flickr fetch url", NULL);
        dispatch_async(downloadQueue, ^{
            NSLog(@"Fetching URL from Flickr for %@", [self.photoDetails valueForKey:FLICKR_PHOTO_ID]);
            NSURL *photoURL = [FlickrFetcher urlForPhoto:self.photoDetails format:FlickrPhotoFormatLarge];
            dispatch_async(dispatch_get_main_queue(), ^{
                [super setImageURL:photoURL];
            });
        });
        dispatch_release(downloadQueue);
        
        [self addPhotoToRecents];
    }
}

@end
