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


- (void)setPhotoDetails:(NSDictionary *)photoDetails
{
    if (_photoDetails != photoDetails) {
        _photoDetails = photoDetails;

        dispatch_queue_t downloadQueue = dispatch_queue_create("flickr image download", NULL);
        dispatch_async(downloadQueue, ^{
            NSURL *photoURL = [FlickrFetcher urlForPhoto:self.photoDetails format:FlickrPhotoFormatLarge];
            dispatch_async(dispatch_get_main_queue(), ^{
                [super setImageURL:photoURL];
            });
        });
        dispatch_release(downloadQueue);
    }
                       
}

@end
