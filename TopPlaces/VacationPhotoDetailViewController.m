//
//  VacationPhotoDetailViewController.m
//  TopPlaces
//
//  Created by Hartman on 8/14/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "VacationPhotoDetailViewController.h"
#import "VacationHelper.h"
#import "FlickrFetcher.h"
#import <CoreData/CoreData.h>
#import "Photo+Flickr.h"

@interface VacationPhotoDetailViewController ()

@end

@implementation VacationPhotoDetailViewController

@synthesize vacationDatabase = _vacationDatabase;

- (void)saveVacation
{
    [self.vacationDatabase saveToURL:self.vacationDatabase.fileURL
                    forSaveOperation:UIDocumentSaveForOverwriting
                   completionHandler:^(BOOL success) {
                       if (!success) NSLog(@"failed to save document %@", self.vacationDatabase.localizedName);
                       [self readyVisitButton];
                   }];
}

- (void)addPhotoToVacation
{
    NSLog(@"Visit Photo");
    [Photo photoWithFlickrInfo:self.photoDetails inManagedObjectContext:self.vacationDatabase.managedObjectContext];
    [self saveVacation];
}

- (void)removePhotoFromVacation
{
    NSLog(@"Unvisit Photo");
    Photo *photo = [Photo photoWithFlickrInfo:self.photoDetails inManagedObjectContext:self.vacationDatabase.managedObjectContext];
    [self.vacationDatabase.managedObjectContext deleteObject:photo];
    [self saveVacation];
}

- (void)readyVisitButton
{
    if (self.vacationDatabase) {
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [self.photoDetails objectForKey:FLICKR_PHOTO_ID]];
        
        NSError *error;
        NSArray *matches= [self.vacationDatabase.managedObjectContext executeFetchRequest:request error:&error];
        
        UIBarButtonItem *visitButton;
        if (!matches || ([matches count] > 1)) {
            // handle error
        }
        else if ([matches count] == 0) {
            visitButton = [[UIBarButtonItem alloc] initWithTitle:@"Visit" style:UIBarButtonItemStyleBordered target:self action:@selector(addPhotoToVacation)];
        }
        else {
            visitButton = [[UIBarButtonItem alloc] initWithTitle:@"Unvisit" style:UIBarButtonItemStyleBordered target:self action:@selector(removePhotoFromVacation)];            
        }
        self.navigationItem.rightBarButtonItem = visitButton;
    }
    else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)setVacationDatabase:(UIManagedDocument *)vacationDatabase
{
    _vacationDatabase = vacationDatabase;
    [self readyVisitButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.vacationDatabase) {
        [VacationHelper openVacation:@"My Vacation" usingBlock:^(UIManagedDocument *vacationDatabase){
            self.vacationDatabase = vacationDatabase;
        }];
    }
}

@end
