//
//  Photo+Flickr.h
//  Virtual Vacation
//
//  Created by Michael Mangold on 5/23/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//
//  Creates a Core Data Photo object from Flickr data.
//

#import "Photo.h"

@interface Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)flickrInfo inManagedObjectContext:(NSManagedObjectContext *)context;

@end
