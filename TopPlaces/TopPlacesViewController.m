//
//  TopPlacesViewController.m
//  TopPlaces
//
//  Created by Michael Hartman on 7/20/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "TopPlacesViewController.h"
#import "FlickrFetcher.h"
#import "PhotosTableViewController.h"

#define MAX_PHOTOS 50

@interface TopPlacesViewController ()
@end

@implementation TopPlacesViewController

@synthesize topPlaces = _topPlaces;

- (NSString *)placeNameFromPhoto: (NSDictionary *)photoDetails
{
    NSString *placeName = [photoDetails valueForKeyPath:FLICKR_PLACE_NAME];
    NSArray *parts = [placeName componentsSeparatedByString:@","];
    if (parts.count > 0) {
        return [parts objectAtIndex:0];
    }
    return nil;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSSortDescriptor *photoPlaceSortDescriptor = [[NSSortDescriptor alloc] initWithKey:FLICKR_PLACE_NAME ascending:YES];
    
    self.topPlaces = [[FlickrFetcher topPlaces] sortedArrayUsingDescriptors:[NSArray arrayWithObject:photoPlaceSortDescriptor]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
        NSDictionary *photoDetails = [self.topPlaces objectAtIndex:indexPath.row];
        PhotosTableViewController *viewController = segue.destinationViewController;      
        viewController.title = [self placeNameFromPhoto:photoDetails];
        viewController.photosInPlace = [FlickrFetcher photosInPlace:photoDetails maxResults:MAX_PHOTOS];
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
