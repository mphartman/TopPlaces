//
//  PhotoDetailViewController.m
//  TopPlaces
//
//  Created by Michael Hartman on 7/24/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "PhotoDetailViewController.h"

@interface PhotoDetailViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation PhotoDetailViewController

@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize photoURL = _photoURL;

- (void)loadPhoto
{
    //NSLog(@"%@", self.photoURL);
    NSData *bits = [NSData dataWithContentsOfURL:self.photoURL];
    UIImage *image = [UIImage imageWithData:bits];
    self.imageView.image = image;
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    [self.scrollView flashScrollIndicators];
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
    [self loadPhoto];
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
