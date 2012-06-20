//
//  VacationPhotosTableViewController.h
//  Virtual Vacation
//
//  Created by Michael Mangold on 6/17/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//
//  Displays a table of Virtual Vacation photos for a given place or tag.
//

#import "CoreDataTableViewController.h"
#import "PhotosTableViewController.h"
#import "Place.h"
#import "Tag.h"

@interface VacationPhotosTableViewController : CoreDataTableViewController <PhotosTableViewControllerDelegate>
@property (nonatomic) id <PhotosTableViewControllerDelegate> delegate;
@property (nonatomic) UIManagedDocument *vacationDocument;
@property (nonatomic) Place *place;
@property (nonatomic) Tag *tag;
@end