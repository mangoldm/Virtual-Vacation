//
//  TagsTableViewController.m
//  Virtual Vacation
//
//  Created by Michael Mangold on 6/16/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//

#import "TagsTableViewController.h"
#import "Photo.h"
#import "ScrollingPhotoViewController.h"
#import "FlickrFetcher.h"
#import "VacationPhotosTableViewController.h"

@interface TagsTableViewController ()
@property Tag *chosenTag;
@end

@implementation TagsTableViewController
@synthesize delegate         = _delegate;
@synthesize vacationDocument = _vacationDocument;
@synthesize chosenTag        = _chosenTag;

#pragma mark - TableView Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure cell.
    static NSString *CellIdentifier = @"Tag Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Execute fetch request and populate cell.
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text       = tag.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Photos:%i", tag.taggedIn.count];
    
    return cell;
}

#pragma mark - TableView delegate.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Photos for Tag"]) {
        VacationPhotosTableViewController *vacationPhotosTableViewController = segue.destinationViewController;
        vacationPhotosTableViewController.vacationDocument = self.vacationDocument;
        vacationPhotosTableViewController.tag              = self.chosenTag;
        vacationPhotosTableViewController.title            = self.chosenTag.name;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.chosenTag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"Show Photos for Tag" sender:self];
}

#pragma mark CoreDataBableViewController

- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"totalPhotosTagged" ascending:NO selector:@selector(localizedCaseInsensitiveCompare:)]];
// No predicate -- all tags returned.
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.vacationDocument.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

#pragma ViewController lifecycle.

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
