//
//  VacationPhotosTableViewController.h
//  Virtual Vacation
//
//  Created by Michael Mangold on 6/17/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//
//  Displays a table of Virtual Vacation photos for a given place.
//

#import "CoreDataTableViewController.h"
#import "Place.h"

@interface VacationPhotosTableViewController : CoreDataTableViewController
@property (nonatomic) UIManagedDocument *vacationDocument;
@property (nonatomic) Place *place;
@end
