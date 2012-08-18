//
//  PhotoDetailViewController.m
//  TopPlaces
//
//  Created by Michael Hartman on 7/24/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "ImageCache.h"

@interface PhotoDetailViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) ImageCache *imageCache;
@property (strong, nonatomic) NSString *photoId;
@end

@implementation PhotoDetailViewController

@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize imageCache = _imageCache;
@synthesize imageURL = _imageURL;

- (ImageCache *)imageCache
{
    if (!_imageCache) _imageCache = [[ImageCache alloc] init];
    return _imageCache;
}

- (void)loadPhotoImage
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr image download", NULL);
    dispatch_async(downloadQueue, ^{
        
        NSData *bits = [self.imageCache dataFromCacheForKey:self.photoId];
        if (!bits) {
            NSLog(@"Loading photo %@ from URL...", self.imageURL);
            bits = [NSData dataWithContentsOfURL:self.imageURL];
            [self.imageCache addDataToCache:bits forKey:self.photoId];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:bits];
            self.imageView.image = image;
            self.scrollView.contentSize = self.imageView.image.size;
            self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
            // zoom image to make "best fit"
            CGFloat widthRatio = self.scrollView.bounds.size.width / image.size.width;
            CGFloat heightRatio = self.scrollView.bounds.size.height / image.size.height;
            CGFloat ratio = MAX(widthRatio, heightRatio);
            [self.scrollView setZoomScale:ratio animated:NO];
        });
    });
    dispatch_release(downloadQueue);
}

- (void)setImageURL:(NSURL *)imageURL
{
    if (_imageURL != imageURL) {
        _imageURL = imageURL;
        self.photoId = [NSString stringWithFormat:@"%d", [self.imageURL hash]];
        [self loadPhotoImage];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.imageURL) [self loadPhotoImage];
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
