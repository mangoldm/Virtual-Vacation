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
#import "ChoicesTableViewController.h"

@interface VacationsTableViewController ()
@property (nonatomic, strong) NSArray *vacationsOnFile; // Array of URLs for all Virtual Vacations.
@property(nonatomic) UIManagedDocument *chosenVacation;
@end

@implementation VacationsTableViewController

@synthesize vacationsOnFile = _vacationsOnFile;
@synthesize chosenVacation  = _chosenVacation;

#pragma mark - Setters and Getters

- (void)setVacationsOnFile:(NSArray *)vacationsOnFile
{
    if (_vacationsOnFile != vacationsOnFile) {
        _vacationsOnFile = vacationsOnFile;
        [self.tableView reloadData];
    }
}

#pragma mark - Unique Methods

// Fills an array property with the URLs of all Vacations on file.
- (void)findVacationsOnFile
{
    self.vacationsOnFile = [[NSArray alloc] init];
    
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
        self.vacationsOnFile = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:documentsURL
                                                             includingPropertiesForKeys:keys
                                                                                options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                                  error:nil];
    }
}

#pragma mark - TableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.vacationsOnFile count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Vacation Cell";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    NSURL *vacationURL     = [self.vacationsOnFile objectAtIndex:indexPath.row];
    NSError *errorForName  = nil;
    NSString *vacationName = nil;
    
    // Open the Virtual Vacation document.
    [vacationURL getResourceValue:&vacationName forKey:NSURLNameKey error:&errorForName];
    [VacationHelper openVacationWithName:vacationName usingBlock:^(UIManagedDocument *vacationDocument) {
        NSError *error              = nil;
        NSManagedObjectContext *moc = vacationDocument.managedObjectContext;
        
        // Build fetch request.
        NSFetchRequest *request          = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        request.sortDescriptors          = [NSArray arrayWithObject:sortDescriptor];
        
        // Execute fetch request.
        NSArray           *places = [moc executeFetchRequest:request error:&error];
        int         placesCount   = [places count];
        cell.textLabel.text       = vacationName;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d places", placesCount];
    }];
    return cell;
}

#pragma mark - TableView delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Vacation"]) {
        ChoicesTableViewController *choicesTVC = segue.destinationViewController;
        choicesTVC.vacationDocument = self.chosenVacation;
    }
}

- (void)goOnVacation:(NSURL *)chosenVacationURL andDo:(void(^)(UIManagedDocument *chosenVacationDocument))completionBlock
{
    NSError *errorForName  = nil;
    NSString *vacationName = nil;
    
    // Open the Virtual Vacation document.
    [chosenVacationURL getResourceValue:&vacationName forKey:NSURLNameKey error:&errorForName];
    [VacationHelper openVacationWithName:vacationName usingBlock:^(UIManagedDocument *chosenVacationDocument) {
        completionBlock(chosenVacationDocument);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *chosenVacationURL = [self.vacationsOnFile objectAtIndex:indexPath.row];
    [self goOnVacation:chosenVacationURL andDo:^(UIManagedDocument *chosenVacationDocument) {
        self.chosenVacation = chosenVacationDocument;
        [self performSegueWithIdentifier:@"Show Vacation" sender:self];
    }];
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self findVacationsOnFile];
}

@end
