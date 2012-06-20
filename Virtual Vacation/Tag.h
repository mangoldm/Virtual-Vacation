//
//  Tag.h
//  Virtual Vacation
//
//  Created by Michael Mangold on 6/20/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * totalPhotosTagged;
@property (nonatomic, retain) NSSet *taggedIn;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addTaggedInObject:(Photo *)value;
- (void)removeTaggedInObject:(Photo *)value;
- (void)addTaggedIn:(NSSet *)values;
- (void)removeTaggedIn:(NSSet *)values;

@end
