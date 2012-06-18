//
//  TagsTableViewController.h
//  Virtual Vacation
//
//  Created by Michael Mangold on 6/16/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//
//  Displays a list of Tags for a Virtual Vacation
//

#import "CoreDataTableViewController.h"
#import "PhotosTableViewController.h"
#import "Tag.h"

@interface TagsTableViewController : CoreDataTableViewController <PhotosTableViewControllerDelegate>
@property (nonatomic, weak) id <PhotosTableViewControllerDelegate> delegate;
@property (nonatomic) UIManagedDocument *vacationDocument;
@end
