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

// Creates a Core Data Photo Entity from Flickr information.
+ (void)addPhotoWithFlickrInfo:(NSDictionary *)flickrInfo
                    toVacation:(NSString *)vacationName
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    // Build fetch request.
    NSFetchRequest *request          = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate                = [NSPredicate predicateWithFormat:@"unique = %@", [flickrInfo objectForKey:FLICKR_PHOTO_ID]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors          = [NSArray arrayWithObject:sortDescriptor];
    
    // Execute fetch request.
    NSError *error   = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@"Photo database error");
    } else if ([matches count] == 0) {
        
        // Construct the Photo from Flickr data.
        photo            = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        
        photo.unique     = [flickrInfo objectForKey:FLICKR_PHOTO_ID];
        photo.title      = [flickrInfo objectForKey:FLICKR_PHOTO_TITLE];
        photo.subtitle   = [flickrInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL   = [[FlickrFetcher urlForPhoto:flickrInfo format:FlickrPhotoFormatLarge] absoluteString];
        
        NSString *tags   = [flickrInfo objectForKey:FLICKR_TAGS];
        photo.taggedAs   = [Tag        tagsFromString:tags forPhotoID:photo.unique inManagedObjectContext:context];
        
        NSString *place  = [flickrInfo objectForKey:FLICKR_PHOTO_PLACE_NAME];
        photo.whereTaken = [Place       placeWithName:place inManagedObjectContext:context];
    } else {
        NSLog(@"Error: photo already on file.");
    }
}

// Deletes a Core Data Photo Entity.
+ (void)deletePhotoWithFlickrInfo:(NSDictionary *)flickrInfo
                     fromVacation:(NSString *)vacationName
           inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    // Build fetch request.
    NSFetchRequest *request          = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate                = [NSPredicate predicateWithFormat:@"unique = %@", [flickrInfo objectForKey:FLICKR_PHOTO_ID]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors          = [NSArray arrayWithObject:sortDescriptor];
    
    // Execute fetch request.
    NSError *error   = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@"Photo database error");
    } else if ([matches count] == 1) {
        
        // Delete the Photo.
        photo = [matches lastObject];
        [context deleteObject:photo];
    } else {
        NSLog(@"Error: photo not on file.");
    }
}

@end
