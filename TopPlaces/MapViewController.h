//
//  MapViewController.h
//  TopPlaces
//
//  Created by Hartman on 7/31/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MapViewController;

@protocol MapViewControllerDelegate <NSObject>

@optional
- (UIImage *)mapViewController:(MapViewController *) sender
            imageForAnnotation:(id <MKAnnotation>) annotation;

- (void)mapViewController:(MapViewController *)sender
      didSelectAnnotation:(id <MKAnnotation>) annotation;

@end

@interface MapViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, weak) id <MapViewControllerDelegate> delegate;
@end
