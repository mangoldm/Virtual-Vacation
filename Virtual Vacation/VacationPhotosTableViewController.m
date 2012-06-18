//
//  VacationPhotosTableViewController.m
//  Virtual Vacation
//
//  Created by Michael Mangold on 6/17/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//

#import "VacationPhotosTableViewController.h"
#import "Photo.h"
#import "ScrollingPhotoViewController.h"
#import "FlickrFetcher.h"

@interface VacationPhotosTableViewController ()
@property (nonatomic) Photo *chosenPhoto;
@end

@implementation VacationPhotosTableViewController
@synthesize vacationDocument = _vacationDocument;
@synthesize place            = _place;
@synthesize chosenPhoto      = _chosenPhoto;

#pragma mark - TableView Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure cell.
    static NSString *CellIdentifier = @"Vacation Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Execute fetch request and populate cell.
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text       = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    
    return cell;
}

#pragma mark - TableView delegate.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Image for Itinerary"]) {
        ScrollingPhotoViewController *scrollingPhotoTableViewController = segue.destinationViewController;
        scrollingPhotoTableViewController.chosenPhoto = (NSDictionary *)self.chosenPhoto;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.chosenPhoto = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"Show Image for Itinerary" sender:self];
}

#pragma mark CoreDataBableViewController

- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    // No predicate because we want all places.
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
