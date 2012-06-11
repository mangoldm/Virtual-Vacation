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
//    
//    Vacation *vacation = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    cell.textLabel.text = vacation.name;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [vacation.photos count]];
    
    return cell;
}

@end
