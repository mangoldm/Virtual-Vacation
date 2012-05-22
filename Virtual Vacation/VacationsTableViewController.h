//
//  VacationsTableViewController.h
//  Virtual Vacation
//
//  Created by Michael Mangold on 5/20/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface VacationsTableViewController : CoreDataTableViewController

@property (nonatomic, strong) UIManagedDocument *vacationDatabase;
@end
