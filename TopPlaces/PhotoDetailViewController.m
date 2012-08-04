//
//  PhotoDetailViewController.m
//  TopPlaces
//
//  Created by Michael Hartman on 7/24/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "FlickrFetcher.h"
#import "ImageCache.h"

@interface PhotoDetailViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) ImageCache *imageCache;
@end

@implementation PhotoDetailViewController

@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize photoDetails = _photoDetails;
@synthesize imageCache = _imageCache;

- (ImageCache *)imageCache
{
    if (!_imageCache) _imageCache = [[ImageCache alloc] init];
    return _imageCache;
}

- (void)loadPhotoImage
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    UIBarButtonItem *rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr image download", NULL);
    dispatch_async(downloadQueue, ^{
        
        NSString *photoId = [self.photoDetails valueForKeyPath:FLICKR_PHOTO_ID];
        
        NSData *bits = [self.imageCache dataFromCacheForKey:photoId];
        if (!bits) {
            NSLog(@"Loading photo %@ from Flickr...", photoId);
            NSURL *photoURL = [FlickrFetcher urlForPhoto:self.photoDetails format:FlickrPhotoFormatLarge];
            bits = [NSData dataWithContentsOfURL:photoURL];
            [self.imageCache addDataToCache:bits forKey:photoId];
        }
        
        UIImage *image = [UIImage imageWithData:bits];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            self.scrollView.contentSize = self.imageView.image.size;
            self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
            // zoom image to make "best fit"
            CGFloat widthRatio = self.scrollView.bounds.size.width / image.size.width;
            CGFloat heightRatio = self.scrollView.bounds.size.height / image.size.height;
            CGFloat ratio = MAX(widthRatio, heightRatio);
            [self.scrollView setZoomScale:ratio animated:NO];
            self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        });
    });
    dispatch_release(downloadQueue);
}

- (void)addPhotoToRecents
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recents = [[prefs objectForKey:@"TopPlaces.RecentPhotos"] mutableCopy];
    if (!recents) {
        recents = [NSMutableArray array];
    }

    // add this photo to the top of list of recents, avoiding adding duplicates based on Photo ID
    BOOL found = NO;
    NSString *photoId = [self.photoDetails valueForKeyPath:FLICKR_PHOTO_ID];
    for (NSDictionary *recentPhoto in recents) {
        if ([photoId isEqualToString:[recentPhoto valueForKeyPath:FLICKR_PHOTO_ID]]) {
            found = YES;
            break;
        }
    }
    if (!found && self.photoDetails) {
        [recents insertObject:self.photoDetails atIndex:0];
    }
    
    [prefs setObject:recents forKey:@"TopPlaces.RecentPhotos"];
    [prefs synchronize];
}

- (void)setPhotoDetails:(NSDictionary *)photoDetails
{
    if (_photoDetails != photoDetails) {
        _photoDetails = photoDetails;
        [self addPhotoToRecents];
        if (self.view.window) [self loadPhotoImage];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
    [self loadPhotoImage];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
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

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
