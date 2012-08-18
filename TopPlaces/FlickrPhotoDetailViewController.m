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

        
        NSURL *photoURL = [FlickrFetcher urlForPhoto:self.photoDetails format:FlickrPhotoFormatLarge];
        [super setImageURL:photoURL];
        
    }
}

@end
