//
//  VacationsTableViewController.m
//  TopPlaces
//
//  Created by Hartman on 8/12/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "VacationsTableViewController.h"
#import "VacationHelper.h"
#import "VacationViewController.h"

@interface VacationsTableViewController ()
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation VacationsTableViewController

@synthesize vacations = _vacations;
@synthesize tableView = _tableView;

- (void)setVacations:(NSArray *)vacations
{
    _vacations = vacations;
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setVacation:)]) {
        NSString *vacationName = [self.vacations objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        [segue.destinationViewController setTitle:vacationName];
        [segue.destinationViewController performSelector:@selector(setVacation:) withObject:vacationName];
    }
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.vacations = [VacationHelper vacationNameList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.vacations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Vacation Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [self.vacations objectAtIndex:indexPath.row];
    
    return cell;
}


@end
