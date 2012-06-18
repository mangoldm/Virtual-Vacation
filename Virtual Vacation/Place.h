//
//  Place.h
//  Virtual Vacation
//
//  Created by Michael Mangold on 6/18/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSDate * addedDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *seenIn;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addSeenInObject:(Photo *)value;
- (void)removeSeenInObject:(Photo *)value;
- (void)addSeenIn:(NSSet *)values;
- (void)removeSeenIn:(NSSet *)values;

@end
