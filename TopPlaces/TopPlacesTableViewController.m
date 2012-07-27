//
//  TopPlacesViewController.m
//  TopPlaces
//
//  Created by Michael Hartman on 7/20/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotosTableViewController.h"

#define MAX_PHOTOS 50

@interface TopPlacesTableViewController ()
@end

@implementation TopPlacesTableViewController

@synthesize topPlaces = _topPlaces;

- (void)setTopPlaces:(NSArray *)topPlaces
{
    if (_topPlaces != topPlaces) {
        _topPlaces = topPlaces;
        [self.tableView reloadData];
    }
}
- (NSString *)placeNameFromPhoto: (NSDictionary *)photoDetails
{
    NSString *placeName = [photoDetails valueForKeyPath:FLICKR_PLACE_NAME];
    NSArray *parts = [placeName componentsSeparatedByString:@","];
    if (parts.count > 0) {
        return [parts objectAtIndex:0];
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSSortDescriptor *photoPlaceSortDescriptor = [[NSSortDescriptor alloc] initWithKey:FLICKR_PLACE_NAME ascending:YES];
    //NSLog(@"Loading top places from Flickr...");
    self.topPlaces = [[FlickrFetcher topPlaces] sortedArrayUsingDescriptors:[NSArray arrayWithObject:photoPlaceSortDescriptor]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Photos of Place"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *place = [self.topPlaces objectAtIndex:indexPath.row];
        PhotosTableViewController *viewController = segue.destinationViewController;      
        viewController.title = [self placeNameFromPhoto:place];
        //NSLog(@"Loading photos for place from Flickr...");
        viewController.photos = [FlickrFetcher photosInPlace:place maxResults:MAX_PHOTOS];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topPlaces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Place Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *photoDetails = [self.topPlaces objectAtIndex:indexPath.row];
    cell.textLabel.text = [self placeNameFromPhoto:photoDetails];

    NSString * placeName = [photoDetails valueForKeyPath:FLICKR_PLACE_NAME];
    NSArray *parts = [placeName componentsSeparatedByString:@","];
    if (parts.count > 2) {
        cell.detailTextLabel.text = [parts objectAtIndex:1];
    } 
    else {
        cell.detailTextLabel.text = nil;
    }
    
    return cell;
}

@end
