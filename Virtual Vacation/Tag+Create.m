//
//  Tag+Create.m
//  Virtual Vacation
//
//  Created by Michael Mangold on 5/24/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//

#import "Tag+Create.h"

@implementation Tag (Create)

// Returns an array of tags from a string of space-delimited tags, creating a new database entry for each individual tag.
+ (NSSet *)tagsFromString:(NSString *)tagsString forPhotoID:(NSString *)unique inManagedObjectContext:(NSManagedObjectContext *)context
{
    Tag *tag = nil;
    NSArray *photoTags= [tagsString componentsSeparatedByString:@" "];
    for (Tag *photoTag in photoTags) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
        request.predicate = [NSPredicate predicateWithFormat:@"taggedIn = %@",unique];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"taggedIn" ascending:YES];
        request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
        NSError *error = nil;
        NSArray *fetchedTags = [context executeFetchRequest:request error:&error];
        
        if (![fetchedTags count]) {
            tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
            tag.name = photoTag.name;
        } else {
            tag = [fetchedTags lastObject];
        }
    }
    NSSet *photoTagsSet = [NSSet setWithArray:photoTags];
    return photoTagsSet;
}

@end
