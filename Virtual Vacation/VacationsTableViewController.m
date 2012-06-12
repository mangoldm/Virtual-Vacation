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
    self.vacationURLs = [[NSArray alloc] initWithArray:[self vacationsOnFile]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *vacationURL = [self.vacationURLs objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"Vacation Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        Vacation *vacation = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = vacation.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [vacation.photos count]];
    
    return cell;
}

@end
