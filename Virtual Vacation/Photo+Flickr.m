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
#import "Vacation+Create.h"

@implementation Photo (Flickr)

// Creates a Core Data Photo Entity from Flickr information or retrieves a Photo if already in the database.
+ (Photo *)photoWithFlickrInfo:(NSDictionary *)flickrInfo
                    onVacation:(NSString *)vacationName
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    //    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:context];
    //    Photo *photo = [[Photo alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    
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
        NSString *tags   = [flickrInfo objectForKey:FLICKR_TAGS];
        NSString *place  = [flickrInfo objectForKey:FLICKR_PLACE_NAME];
        photo            = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.onVacation = [Vacation vacationWithName:vacationName inManagedObjectContext:context];
        photo.unique     = [flickrInfo objectForKey:FLICKR_PHOTO_ID];
        photo.title      = [flickrInfo objectForKey:FLICKR_PHOTO_TITLE];
        NSLog(@"photo.title:%@",photo.title);
        photo.subtitle   = [flickrInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL   = [[FlickrFetcher urlForPhoto:flickrInfo format:FlickrPhotoFormatLarge] absoluteString];
        photo.whereTaken = [Place placeWithName:place inManagedObjectContext:context];
        photo.taggedAs   = [Tag tagsFromString:tags forPhotoID:photo.unique inManagedObjectContext:context];
    } else {
        
        // Retrieve the Photo if already in the database.
        photo = [matches lastObject];
    }
    return photo;
}
@end
