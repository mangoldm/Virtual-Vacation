//
//  ChoicesTableViewController.m
//  Virtual Vacation
//
//  Created by Michael Mangold on 6/15/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//

#import "ChoicesTableViewController.h"
#import "CoreDataTableViewController.h"
#import "ItineraryTableViewController.h"
#import "TagsTableViewController.h"

@interface ChoicesTableViewController ()

@end

@implementation ChoicesTableViewController
@synthesize vacationDocument = _vacationDocument;

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSError *error;
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        
        // Configure Itinerary cell.        
        static NSString *CellIdentifier = @"Itinerary Choice Cell";
        UITableViewCell *itineraryCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (itineraryCell == nil) {
            itineraryCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        // Build fetch request.
        NSFetchRequest *request          = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        request.sortDescriptors          = [NSArray arrayWithObject:sortDescriptor];
        
        // Execute fetch request.
        NSArray           *places = [self.vacationDocument.managedObjectContext executeFetchRequest:request error:&error];
        int         placesCount   = [places count];
        itineraryCell.detailTextLabel.text = [NSString stringWithFormat:@"%d places", placesCount];
        itineraryCell.textLabel.text       = @"Itinerary";
        cell = itineraryCell;
    } else {
        
        // Configure Tag Search cell.
        static NSString *CellIdentifier = @"Tag Search Choice Cell";
        UITableViewCell *tagSearchCell  = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (tagSearchCell == nil) {
            tagSearchCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        // Build fetch request.
        NSFetchRequest *request          = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        request.sortDescriptors          = [NSArray arrayWithObject:sortDescriptor];
        
        // Execute fetch request.
        NSArray *tags = [self.vacationDocument.managedObjectContext executeFetchRequest:request error:&error];
        int tagsCount   = [tags count];
        tagSearchCell.detailTextLabel.text = [NSString stringWithFormat:@"%d tags", tagsCount];
        tagSearchCell.textLabel.text       = @"Tag Search";
        cell = tagSearchCell;
    }
    return cell;
}

#pragma mark - ViewController delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Itinerary"]) {
        ItineraryTableViewController *itineraryTableViewController = segue.destinationViewController;
        itineraryTableViewController.vacationDocument = self.vacationDocument;
    } else if ([segue.identifier isEqualToString:@"Show Tags"]) {
        TagsTableViewController *tagsTableViewController = segue.destinationViewController;
        tagsTableViewController.vacationDocument = self.vacationDocument;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"Show Itinerary" sender:self];
    } else {
        if (indexPath.row == 1) {
            [self performSegueWithIdentifier:@"Show Tags" sender:self];
        }
    }
}

#pragma mark - View lifecycle.

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set title to the vacation's name.
    NSURL *vacationURL     = self.vacationDocument.fileURL;
    NSError *errorForName  = nil;
    NSString *vacationName = nil;
    [vacationURL getResourceValue:&vacationName forKey:NSURLNameKey error:&errorForName];
    self.title = vacationName;
    self.tableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


@end
