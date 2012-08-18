//
//  SearchTagsTableViewController.m
//  TopPlaces
//
//  Created by Hartman on 8/17/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "SearchTagsTableViewController.h"
#import "SearchTag.h"
#import "VacationHelper.h"
#import "CoreDataPhotosTableViewController.h"

@interface SearchTagsTableViewController ()
@property (nonatomic, strong) UIManagedDocument *vacationDatabase;
@end

@implementation SearchTagsTableViewController

@synthesize vacation = _vacation;
@synthesize vacationDatabase = _vacationDatabase;

- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SearchTag"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    
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
        SearchTag *searchTag = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        CoreDataPhotosTableViewController *tvc = segue.destinationViewController;
        tvc.photos = [searchTag.photos allObjects];
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
    static NSString *CellIdentifier = @"Tag Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // ask NSFetchedResultsController for the NSMO at the row in question
    SearchTag *searchTag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Then configure the cell using it ...
    cell.textLabel.text = searchTag.name;
    if ([searchTag.photos count] == 1) {
        cell.detailTextLabel.text = @"1 photo";
    }
    else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [searchTag.photos count]];
    }
    
    return cell;
}

@end
