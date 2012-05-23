//
//  Vacation.h
//  Virtual Vacation
//
//  Created by Michael Mangold on 5/22/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, Place;

@interface Vacation : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *itinerary;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Vacation (CoreDataGeneratedAccessors)

- (void)addItineraryObject:(Place *)value;
- (void)removeItineraryObject:(Place *)value;
- (void)addItinerary:(NSSet *)values;
- (void)removeItinerary:(NSSet *)values;

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
