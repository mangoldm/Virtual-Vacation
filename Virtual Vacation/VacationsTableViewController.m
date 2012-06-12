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

@interface VacationsTableViewController ()
@property (weak, nonatomic) NSArray *vacationURLs;
@end

@implementation VacationsTableViewController

@synthesize vacationDatabase = _vacationDatabase;
@synthesize vacationURLs     = _vacationURLs;

- (void)useDocument
{
    if (self.vacationDatabase.documentState == UIDocumentStateNormal) {
        // already open and ready to use
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

// Determines what data populates the Vacations Table
- (void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Vacation"];
    
    // No predicate specified because we want all vacations.
    request.sortDescriptors = [NSArray arrayWithObject: [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                                      ascending:YES
                                                                                       selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.vacationDatabase.managedObjectContext
                                                                          sectionNameKeyPath:@"Section" cacheName:nil];
}

// Returns an array of all the Vacations on file.
- (NSArray *)vacationsOnFile
{
    NSArray *localURLs = [[NSArray alloc] init];
    // Identify the documents folder URL.
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *errorForURLs      = nil;
    NSURL *documentsURL        = [fileManager URLForDirectory:NSDocumentDirectory
                                                     inDomain:NSUserDomainMask
                                            appropriateForURL:nil
                                                       create:NO
                                                        error:&errorForURLs];
    if (documentsURL == nil) {
        NSLog(@"Could not access documents directory\n%@", [errorForURLs localizedDescription]);
    } else {
        
        // Retrieve the vacation stores on file.
        NSArray *keys = [NSArray arrayWithObjects:NSURLLocalizedNameKey, nil];
        localURLs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:documentsURL
                                                     includingPropertiesForKeys:keys
                                                                        options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                          error:nil];
    }
    return localURLs;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.tableView.delegate = self;
    self.vacationURLs = [[NSArray alloc] initWithArray:[self vacationsOnFile]];
    for (NSURL *url in self.vacationURLs) {
        self.vacationDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *vacationURL     = [self.vacationURLs objectAtIndex:indexPath.row];
    NSError *errorForName  = nil;
    NSString *vacationName = nil;
    [vacationURL getResourceValue:&vacationName forKey:NSURLNameKey error:&errorForName];
    
    static NSString *CellIdentifier = @"Vacation Cell";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        NSArray *photos = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text       = vacationName;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [photos count]];
    
    return cell;
}

@end
