//
//  ItineraryViewController.m
//  TopPlaces
//
//  Created by Hartman on 8/16/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "ItineraryTableViewController.h"
#import "Place.h"
#import "VacationHelper.h"
#import "CoreDataPhotosTableViewController.h"

@interface ItineraryTableViewController ()
@property (nonatomic, strong) UIManagedDocument *vacationDatabase;
@end

@implementation ItineraryTableViewController

@synthesize vacation = _vacation;
@synthesize vacationDatabase = _vacationDatabase;

- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    // no predicate because we want ALL the Places
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.vacationDatabase.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)setVacationDatabase:(UIManagedDocument *)vacationDatabase
{
    if (_vacationDatabase != vacationDatabase) {
        _vacationDatabase = vacationDatabase;
        [self setupFetchedResultsController];
    }
}

- (void)setVacation:(NSString *)vacation
{
    if (_vacation != vacation) {
        _vacation = vacation;
         [VacationHelper openVacation:self.vacation usingBlock:^(UIManagedDocument *vacationDatabase){
             self.vacationDatabase = vacationDatabase;
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Photos"]) {
        Place *place = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        CoreDataPhotosTableViewController *tvc = segue.destinationViewController;
        tvc.photos = [place.photos allObjects];
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

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Vacation Place Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // ask NSFetchedResultsController for the NSMO at the row in question
    Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Then configure the cell using it ...
    cell.textLabel.text = place.name;
    
    return cell;
}
@end
