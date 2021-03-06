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
#import "MapViewController.h"
#import "FlickrPlaceAnnotation.h"

@interface TopPlacesTableViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation TopPlacesTableViewController

@synthesize tableView = _tableView;
@synthesize topPlaces = _topPlaces;

- (IBAction)refresh:(id)sender
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    UIBarButtonItem *rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("fetch flickr top places", NULL);
    dispatch_async(downloadQueue, ^{
        // sort top places by name in alphabetical order
        NSSortDescriptor *photoPlaceSortDescriptor = [[NSSortDescriptor alloc] initWithKey:FLICKR_PLACE_NAME ascending:YES];
        NSLog(@"Loading top places from Flickr...");
        NSArray *topPlaces = [[FlickrFetcher topPlaces] sortedArrayUsingDescriptors:[NSArray arrayWithObject:photoPlaceSortDescriptor]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.topPlaces = topPlaces;
            self.navigationItem.rightBarButtonItem = rightBarButtonItem; // put button back
        });
    });
    dispatch_release(downloadQueue);
}

- (void)setTopPlaces:(NSArray *)topPlaces
{
    if (_topPlaces != topPlaces) {
        _topPlaces = topPlaces;
        if (self.view.window) [self.tableView reloadData];
        if (self.splitViewController) {
            UINavigationController *nvc = [self.splitViewController.viewControllers lastObject];
            MapViewController *vc = [nvc.viewControllers objectAtIndex:0];
            vc.annotations = [self mapAnnotations];
        }
    }
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refresh:self.navigationItem.rightBarButtonItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.splitViewController) {
        UINavigationController *nvc = [self.splitViewController.viewControllers lastObject];
        [nvc popToRootViewControllerAnimated:YES];
        MapViewController *mapVC = [nvc.viewControllers objectAtIndex:0];
        mapVC.annotations = [self mapAnnotations];
    }
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
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

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray array];
    for (NSDictionary *place in self.topPlaces) {
        [annotations addObject:[FlickrPlaceAnnotation annotationForPlace:place]];
    }
    return annotations;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Photos of Place"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSDictionary *flickrPlace = [self.topPlaces objectAtIndex:indexPath.row];
        PhotosTableViewController *viewController = segue.destinationViewController;      
        viewController.title = cell.textLabel.text;
        viewController.flickrPlace = flickrPlace;
    }
    else if ([segue.identifier isEqualToString:@"Show Places on Map"]) {
        MapViewController *viewController = segue.destinationViewController;
        viewController.title = self.title;
        viewController.annotations = [self mapAnnotations];
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
    
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    
    NSDictionary *flickrPlace = [self.topPlaces objectAtIndex:indexPath.row];
    
    // Place Name is a comma-separated value.  First part is the place, next part (if available) is the country
    // use place for title
    // use country for subtitle
    NSString *placeName = [flickrPlace valueForKeyPath:FLICKR_PLACE_NAME];
    NSArray *parts = [placeName componentsSeparatedByString:@","];
    if (parts.count > 0) {
        cell.textLabel.text = [parts objectAtIndex:0];
        if (parts.count > 1) {
            cell.detailTextLabel.text = [parts objectAtIndex:1];
        }
    }
    
    return cell;
}

@end
