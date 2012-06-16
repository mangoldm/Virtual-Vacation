//
//  ItineraryTableViewController.h
//  Virtual Vacation
//
//  Created by Michael Mangold on 6/16/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//
//  Displays a list of places for a Virtual Vacation
//

#import "CoreDataTableViewController.h"

@interface ItineraryTableViewController : CoreDataTableViewController
@property (nonatomic) UIManagedDocument *vacationDocument;
@end
