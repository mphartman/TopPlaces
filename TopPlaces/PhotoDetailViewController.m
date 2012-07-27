//
//  PhotoDetailViewController.m
//  TopPlaces
//
//  Created by Michael Hartman on 7/24/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "FlickrFetcher.h"

@interface PhotoDetailViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) BOOL newPhoto;
@end

@implementation PhotoDetailViewController

@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize photoDetails = _photoDetails;
@synthesize newPhoto = _newPhoto;

- (void)setPhotoDetails:(NSDictionary *)photoDetails
{
    if (_photoDetails != photoDetails) {
        _photoDetails = photoDetails;
        self.newPhoto = YES;
    }
}

- (void)loadPhoto
{
    if (!self.newPhoto) return;
    NSLog(@"Loading photo from Flickr...");
    NSURL *photoURL = [FlickrFetcher urlForPhoto:self.photoDetails format:FlickrPhotoFormatLarge];
    NSData *bits = [NSData dataWithContentsOfURL:photoURL];
    UIImage *image = [UIImage imageWithData:bits];
    self.imageView.image = image;
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    self.newPhoto = NO;
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
    for (NSDictionary *photoDetails in recents) {
        if ([photoId isEqualToString:[photoDetails valueForKeyPath:FLICKR_PHOTO_ID]]) {
            found = YES;
            break;
        }
    }
    if (!found) {
        [recents insertObject:self.photoDetails atIndex:0];
    }
    
    [prefs setObject:recents forKey:@"TopPlaces.RecentPhotos"];
    [prefs synchronize];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadPhoto];
    [self addPhotoToRecents];
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
