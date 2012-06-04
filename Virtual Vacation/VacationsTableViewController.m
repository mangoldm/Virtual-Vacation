//
//  VacationsTableViewController.m
//  Virtual Vacation
//
//  Created by Michael Mangold on 5/20/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
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

// Populate photo table with test data -- I don't think I need this, as photos will already be available in the places, photos, and recents table view controllers.
//- (void)fetchFlickrDataIntoDocument:(UIManagedDocument *)document
//{
//    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr fetcher", NULL);
//    dispatch_async(fetchQ, ^{
//        NSArray *photos = [FlickrFetcher recentGeoreferencedPhotos];
//        [document.managedObjectContext performBlock:^{
//            for (NSDictionary *flickrInfo in photos) {
//                [Photo photoWithFlickrInfo:flickrInfo inManagedObjectContext:document.managedObjectContext];
//            }
//        }];
//    });
//    dispatch_release(fetchQ);
//}

//- (void)useDocument
//{
//    NSLog(@"url:%@",[self.vacationDatabase.fileURL path]);
//    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.vacationDatabase.fileURL path]]) {
//        [self.vacationDatabase saveToURL:self.vacationDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
//            [self setupFetchedResultsController];
//            [self fetchFlickrDataIntoDocument:self.vacationDatabase];
//        }];
//    } else if (self.vacationDatabase.documentState == UIDocumentStateClosed) {
//        [self.vacationDatabase openWithCompletionHandler:^(BOOL success) {
//            [self setupFetchedResultsController];
//        }];
//    } else if (self.vacationDatabase.documentState == UIDocumentStateNormal) {
//        [self setupFetchedResultsController];
//    }
//}

//- (void)setVacationDatabase:(UIManagedDocument *)vacationDatabase
//{
//    if (_vacationDatabase != vacationDatabase) {
//        _vacationDatabase  = vacationDatabase;
//        [self useDocument];
//    }
//}

// Returns an array of all the Vacations on file.
+ (NSArray *)vacationsOnFile
{
    // Identify the documents folder URL.
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error             = nil;
    NSURL *documentsURL        = [fileManager URLForDirectory:NSDocumentDirectory
                                                     inDomain:NSUserDomainMask
                                            appropriateForURL:nil
                                                       create:NO
                                                        error:&error];
    if (documentsURL == nil) {
        NSLog(@"Could not access documents directory\n%@", [error localizedDescription]);
    }
    
    // Populate the array with vacation filenames in the documents directory.
    error              = nil;
    NSArray *keys      = [NSArray arrayWithObjects:NSURLNameKey, NSURLTypeIdentifierKey, nil];
    NSArray *vacations = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:documentsURL 
                                                       includingPropertiesForKeys:keys
                                                                          options:0
                                                                            error:&error];
    return vacations;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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
