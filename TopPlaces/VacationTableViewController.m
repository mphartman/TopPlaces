//
//  VacationViewController.m
//  TopPlaces
//
//  Created by Hartman on 8/16/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "VacationTableViewController.h"

@interface VacationTableViewController ()

@end

@implementation VacationTableViewController

@synthesize vacation = _vacation;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setVacation:)]) {
        [segue.destinationViewController performSelector:@selector(setVacation:) withObject:self.vacation];
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

@end
