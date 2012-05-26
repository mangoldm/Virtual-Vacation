//
//  VacationsTableViewController.m
//  Virtual Vacation
//
//  Created by Michael Mangold on 5/20/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//
//  Displays a user's Virtual Vacations
//

#import "VacationsTableViewController.h"
#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Tag.h"
#import "Place.h"
#import "Vacation.h"

@interface VacationsTableViewController ()

@end

@implementation VacationsTableViewController

@synthesize vacationDatabase = _vacationDatabase;

// Determines what data populates the Vacations Table
- (void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Vacation"];
    
    // No predicate specified because we want all vacations.
    request.sortDescriptors = [NSArray arrayWithObject:
                               [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                             ascending:YES
                                                              selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request
                                     managedObjectContext:self.vacationDatabase.managedObjectContext
                                     sectionNameKeyPath:@"Section" cacheName:nil];
}

// Populate database with test data
- (void)fetchFlickrDataIntoDocument:(UIManagedDocument *)document
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSArray *photos = [FlickrFetcher recentGeoreferencedPhotos];
        [document.managedObjectContext performBlock:^{
            for (NSDictionary *flickrInfo in photos) {
                [Photo photoWithFlickrInfo:flickrInfo inManagedObjectContext:document.managedObjectContext];
            }
        }];
    });
    dispatch_release(fetchQ);
}

- (void)useDocument
{
    NSLog(@"url:%@",[self.vacationDatabase.fileURL path]);
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.vacationDatabase.fileURL path]]) {
        [self.vacationDatabase saveToURL:self.vacationDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
            [self fetchFlickrDataIntoDocument:self.vacationDatabase];
        }];
    } else if (self.vacationDatabase.documentState == UIDocumentStateClosed) {
        [self.vacationDatabase openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
    } else if (self.vacationDatabase.documentState == UIDocumentStateNormal) {
        [self setupFetchedResultsController];
    }
}

- (void)setVacationDatabase:(UIManagedDocument *)vacationDatabase
{
    if (_vacationDatabase != vacationDatabase) {
        _vacationDatabase  = vacationDatabase;
        [self useDocument];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (!self.vacationDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Vacation Database"];
        self.vacationDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Vacation Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Vacation *vacation = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = vacation.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [vacation.photos count]];
    
    return cell;
}

@end
