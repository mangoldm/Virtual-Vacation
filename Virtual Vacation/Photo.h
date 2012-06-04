//
//  Photo.h
//  Virtual Vacation
//
//  Created by Michael Mangold on 6/3/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place, Tag, Vacation;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) Vacation *onVacation;
@property (nonatomic, retain) NSSet *taggedAs;
@property (nonatomic, retain) Place *whereTaken;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addTaggedAsObject:(Tag *)value;
- (void)removeTaggedAsObject:(Tag *)value;
- (void)addTaggedAs:(NSSet *)values;
- (void)removeTaggedAs:(NSSet *)values;

@end
