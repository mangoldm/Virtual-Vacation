//
//  Place.h
//  Virtual Vacation
//
//  Created by Michael Mangold on 5/27/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, Vacation;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * addedDate;
@property (nonatomic, retain) NSSet *seenIn;
@property (nonatomic, retain) Vacation *visitedOnVacation;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addSeenInObject:(Photo *)value;
- (void)removeSeenInObject:(Photo *)value;
- (void)addSeenIn:(NSSet *)values;
- (void)removeSeenIn:(NSSet *)values;

@end
