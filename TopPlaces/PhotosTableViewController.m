//
//  PhotosTableViewController.m
//  TopPlaces
//
//  Created by Michael Hartman on 7/24/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "FlickrFetcher.h"
#import "FlickrPhotoDetailViewController.h"
#import "MapViewController.h"
#import "FlickrPhotoAnnotation.h"

// Maximum number of Flickr photos to show for a given place
#define MAX_PHOTOS 50

@interface PhotosTableViewController () <MapViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *photos;  // array of NSDictionary describing Flickr photos
@end

@implementation PhotosTableViewController

@synthesize flickrPlace = _flickrPlace;
@synthesize tableView = _tableView;
@synthesize photos = _photos;

- (void)loadPhotosForPlace
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    UIBarButtonItem *rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr photos for place", NULL);
    dispatch_async(downloadQueue, ^{
        NSLog(@"Loading photos for place from Flickr");
        NSArray *photos = [FlickrFetcher photosInPlace:self.flickrPlace maxResults:MAX_PHOTOS];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = photos;
            self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        });
    });
    dispatch_release(downloadQueue);
}

- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    [self loadPhotosForPlace];
}

- (void)setFlickrPlace:(NSDictionary *)flickrPlace
{
    if (_flickrPlace != flickrPlace) {
        _flickrPlace = flickrPlace;
        if (self.view.window) [self loadPhotosForPlace];
    }
}

- (void)setPhotos:(NSArray *)photos
{
    if (_photos != photos) {
        _photos = photos;
        if (self.view.window) [self.tableView reloadData];
        if (self.splitViewController) {
            UINavigationController *nvc = [self.splitViewController.viewControllers lastObject];
            MapViewController *vc = [nvc.viewControllers objectAtIndex:0];
            vc.title = self.title;
            vc.annotations = [self mapAnnotations];
        }
    }
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}

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
    for (NSDictionary *photo in self.photos) {
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Photo Detail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        FlickrPhotoDetailViewController *viewController = segue.destinationViewController;
        viewController.title = cell.textLabel.text;
        viewController.photoDetails = photo;
    }
    else if ([segue.identifier isEqualToString:@"Show Photos on Map"]) {
        MapViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
        viewController.title = self.title;
        viewController.annotations = [self mapAnnotations];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];

    // If the photo has no title, use its description as the title. 
    // If it has no title or description, use “Unknown” as the title.
    NSString *title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    NSString *description;
    if (title.length == 0) {
        title = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    } else {
        description = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    }
    if (title.length == 0) {
        title = @"Unknown";
    }
    cell.textLabel.text = title;
    cell.detailTextLabel.text = description;
    return cell;
}

#pragma mark - MapViewControllerDelegate

- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id<MKAnnotation>)annotation
{
    FlickrPhotoAnnotation *photoAnnotation = annotation;
    NSLog(@"Loading thumbnail photo %@ from Flickr...", [photoAnnotation.photo valueForKeyPath:FLICKR_PHOTO_ID]);
    NSURL *url = [FlickrFetcher urlForPhoto:photoAnnotation.photo format:FlickrPhotoFormatSquare];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data ? [UIImage imageWithData:data] : nil;
}

@end
