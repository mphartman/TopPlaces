//
//  RecentsTableViewController.h
//  TopPlaces
//
//  Created by Hartman on 7/26/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentsTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *recentPhotos; // array of NSDictionary with Flickr photo details
@end
