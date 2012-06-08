//
//  Photo+Flickr.h
//  Virtual Vacation
//
//  Created by Michael Mangold on 5/23/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//
// Creates a Core Data Photo Entity from Flickr information or retrieves a Photo if already in the database.
//

#import "Photo.h"

@interface Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)flickrInfo
                    onVacation:(NSString *)vacationName
        inManagedObjectContext:(NSManagedObjectContext *)context;

@end
