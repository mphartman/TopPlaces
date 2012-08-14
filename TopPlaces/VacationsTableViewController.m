//
//  VacationsTableViewController.m
//  TopPlaces
//
//  Created by Hartman on 8/12/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "VacationsTableViewController.h"
#import "VacationHelper.h"

@interface VacationsTableViewController ()
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation VacationsTableViewController

@synthesize vacations = _vacations;
@synthesize tableView = _tableView;

- (void)setVacations:(NSArray *)vacations
{
    _vacations = vacations;
    if (self.view.window) [self.tableView reloadData];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.vacations) {
        self.vacations = [VacationHelper vacationNameList];
    }
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
