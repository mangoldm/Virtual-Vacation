//
//  Tag+Create.m
//  Virtual Vacation
//
//  Created by Michael Mangold on 5/24/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//

#import "Tag+Create.h"

@implementation Tag (Create)

// Returns a set of tags from a string of space-delimited tags, creating a new database entry for each individual tag.

+ (NSSet *)tagsFromString:(NSString *)tagsString forPhotoID:(NSString *)unique inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *photoTags = [tagsString componentsSeparatedByString:@" "];
    for (NSString *photoTag in photoTags) {
        
        Tag *tag = nil;
        
        NSFetchRequest *request          = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
        request.predicate                = [NSPredicate predicateWithFormat:@"name = %@",photoTag];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        request.sortDescriptors          = [NSArray arrayWithObject:sortDescriptor];
        
        NSError *error       = nil;
        NSArray *fetchedTags = [context executeFetchRequest:request error:&error];
        
        // Add new tag if one doesn't already exist, otherwise use the tag already on-file.
        if (![fetchedTags count]) {
            tag      = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
            tag.name = photoTag;
        } else tag   = [fetchedTags lastObject];
        [photoTags arrayByAddingObject:tag];
    }
    NSSet *photoTagsSet = [NSSet setWithArray:photoTags];
    return photoTagsSet;
}

@end
