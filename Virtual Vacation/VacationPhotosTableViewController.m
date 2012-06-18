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
@synthesize delegate         = _delegate;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Retrieve the chosen photo.
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // ScrollingPhotoViewController is expecting an NSDictionary Flickr photo, not a Core Data photo.
    NSArray *keys                 = [NSArray arrayWithObjects:FLICKR_PHOTO_ID, FLICKR_PHOTO_TITLE, nil];
    NSArray *objects              = [NSArray arrayWithObjects:photo.unique, photo.title, nil];
    NSDictionary *photoDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [self.delegate viewController:self chosePhoto:photoDictionary];
}

#pragma mark CoreDataBableViewController

- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"whereTaken == %@", self.place];
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
