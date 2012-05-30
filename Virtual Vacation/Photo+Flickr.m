//
//  Photo+Flickr.m
//  Virtual Vacation
//
//  Created by Michael Mangold on 5/23/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Place+Create.h"
#import "Tag+Create.h"

@implementation Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)flickrInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    NSFetchRequest *request          = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate                = [NSPredicate predicateWithFormat:@"unique = %@", [flickrInfo objectForKey:FLICKR_PHOTO_ID]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors          = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error   = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@"Photo database error");
    } else if ([matches count] == 0) {
        NSString *tags   = [flickrInfo objectForKey:FLICKR_TAGS];
        photo            = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.unique     = [flickrInfo objectForKey:FLICKR_PHOTO_ID];
        photo.title      = [flickrInfo objectForKey:FLICKR_PHOTO_TITLE];
        photo.subtitle   = [flickrInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL   = [[FlickrFetcher urlForPhoto:flickrInfo format:FlickrPhotoFormatLarge] absoluteString];
        photo.whereTaken = [Place placeWithName:FLICKR_PHOTO_PLACE_NAME inManagedObjectContext:context];
        photo.taggedAs   = [Tag tagsFromString:tags forPhotoID:photo.unique inManagedObjectContext:context];
    } else {
        photo = [matches lastObject];
    }
    
    return photo;
}

@end