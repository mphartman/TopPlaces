//
//  CoreDataPhotosTableViewController.m
//  TopPlaces
//
//  Created by Hartman on 8/17/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "CoreDataPhotosTableViewController.h"
#import "Photo.h"
#import "VacationPhotoDetailViewController.h"

@interface CoreDataPhotosTableViewController ()

@end

@implementation CoreDataPhotosTableViewController

@synthesize photos = _photos;

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    if (self.tableView.window) [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Photo Detail"]) {
        VacationPhotoDetailViewController *viewController = segue.destinationViewController;
        Photo *photo = [self.photos objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
}

#pragma mark - Auto Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Detail Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Photo *photo = [self.photos objectAtIndex:indexPath.row];
    // Then configure the cell using it ...
    cell.textLabel.text = photo.title;
    
    return cell;
}

@end
