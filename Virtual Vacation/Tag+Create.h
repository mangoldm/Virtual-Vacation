//
//  Tag+Create.h
//  Virtual Vacation
//
//  Created by Michael Mangold on 5/24/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//
//  Creates database entries for photo tags.
//

#import "Tag.h"
#import "Photo.h"

@interface Tag (Create)

+ (NSSet *)tagsFromString:(NSString *)tagsString forPhotoID:(NSString *)unique inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)oneLessPhotoWithTag:(NSString *)tagName inManagedObjectContext:(NSManagedObjectContext *)context;

@end
