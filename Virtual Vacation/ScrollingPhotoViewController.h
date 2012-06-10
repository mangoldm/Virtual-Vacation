//
//  ScrollingPhotoViewController.h
//  PhotoMap
//
//  Created by Michael Mangold on 3/6/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//  CS193P (Fall, 2011) Assignment #5
//
//  Displays a single photo which can be zoomed and scrolled.
//

#import <UIKit/UIKit.h>
#import "PhotosTableViewController.h"
#import "Photo.h"
#import "VacationHelper.h"

#define MAXIMUM_CACHE_SIZE 10000000 // 10MB
#define TITLE_ADD_TO_VACATION @"Visit"
#define TITLE_REMOVE_FROM_VACATION @"Unvisit"

@interface ScrollingPhotoViewController : UIViewController <UINavigationBarDelegate, PhotosTableViewControllerDelegate>

- (IBAction)vacation:(UIBarButtonItem *)sender;
- (IBAction)dismissPhoto:(UITapGestureRecognizer *)sender;

@property (nonatomic, strong) NSDictionary *chosenPhoto;
@end