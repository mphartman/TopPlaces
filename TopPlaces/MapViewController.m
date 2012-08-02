//
//  MapViewController.m
//  TopPlaces
//
//  Created by Hartman on 7/31/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "MapViewController.h"
#import "PhotosTableViewController.h"
#import "FlickrPlaceAnnotation.h"
#import "PhotoDetailViewController.h"
#import "FlickrPhotoAnnotation.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize delegate = _delegate;

-(void)updateMapView
{
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) [self.mapView addAnnotations:self.annotations];
    
    // zoom to a region which includes all annotations
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    [self.mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(5, 5, 5, 5) animated:YES];
}

-(void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

-(void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"TopPlaces.MapVC"];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"TopPlaces.MapVC"];
        view.canShowCallout = YES;
        view.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    view.annotation = annotation;
    [(UIImageView *)view.leftCalloutAccessoryView setImage:nil];
    return view;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([self.delegate respondsToSelector:@selector(mapViewController:imageForAnnotation:)]) {
        dispatch_queue_t aQueue = dispatch_queue_create("annotation image queue", NULL);
        dispatch_async(aQueue, ^{
            UIImage *image = [self.delegate mapViewController:self imageForAnnotation:view.annotation];
            dispatch_async(dispatch_get_main_queue(), ^{
                [(UIImageView *)view.leftCalloutAccessoryView setImage:image];
            });
        });
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([control isKindOfClass:[UIButton class]]) {
        if ([view.annotation isKindOfClass:[FlickrPlaceAnnotation class]]) {
        [self performSegueWithIdentifier:@"Show Photos of Place" sender:view.annotation];
        }
        else if ([view.annotation isKindOfClass:[FlickrPhotoAnnotation class]]) {
            [self performSegueWithIdentifier:@"Show Photo Detail" sender:view.annotation];
        }
    }
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}

#pragma mark - Auto rotation

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
        FlickrPlaceAnnotation *placeAnnotation = sender;
        PhotosTableViewController *viewController = segue.destinationViewController;
        viewController.title = placeAnnotation.title;
        viewController.flickrPlace = placeAnnotation.place;
    }
    else if ([segue.identifier isEqualToString:@"Show Photo Detail"]) {
        FlickrPhotoAnnotation *photoAnnotation = sender;
        PhotoDetailViewController *viewController = segue.destinationViewController;
        viewController.title = photoAnnotation.title;
        viewController.photoDetails = photoAnnotation.photo;
    }
}
@end
