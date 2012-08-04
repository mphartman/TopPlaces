//
//  RecentsTableViewController.m
//  TopPlaces
//
//  Created by Hartman on 7/26/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "RecentsTableViewController.h"
#import "FlickrFetcher.h"
#import "FlickrPhotoAnnotation.h"
#import "MapViewController.h"

@interface RecentsTableViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation RecentsTableViewController

@synthesize tableView = _tableView;
@synthesize recentPhotos = _recentPhotos;


- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray array];
    for (NSDictionary *photo in self.recentPhotos) {
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}

- (void)setRecentPhotos:(NSArray *)recentPhotos
{
    if (_recentPhotos != recentPhotos) {
        _recentPhotos = recentPhotos;
        [self.tableView reloadData];
        if (self.splitViewController) {
            UINavigationController *nvc = [self.splitViewController.viewControllers lastObject];
            MapViewController *vc = [nvc.viewControllers objectAtIndex:0];
            vc.title = self.title;
            vc.annotations = [self mapAnnotations];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.recentPhotos = [prefs objectForKey:@"TopPlaces.RecentPhotos"];
    if (self.splitViewController) {
        UINavigationController *nvc = [self.splitViewController.viewControllers lastObject];
        [nvc popToRootViewControllerAnimated:YES];
        MapViewController *mapVC = [nvc.viewControllers objectAtIndex:0];
        mapVC.annotations = [self mapAnnotations];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recentPhotos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Recent Photo Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [[self.recentPhotos objectAtIndex:indexPath.row] valueForKeyPath:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = nil;
    
    return cell;
}

@end
