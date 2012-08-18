//
//  FlickrPhotoDetailViewController.h
//  TopPlaces
//
//  Created by Hartman on 8/17/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoDetailViewController.h"

@interface FlickrPhotoDetailViewController : PhotoDetailViewController

@property (nonatomic, strong) NSDictionary *photoDetails;  // a Flickr photo

@end
