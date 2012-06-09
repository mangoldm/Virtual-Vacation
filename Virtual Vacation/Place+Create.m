//
//  Place+Create.m
//  Virtual Vacation
//
//  Created by Michael Mangold on 5/24/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//

#import "Place+Create.h"

@implementation Place (Create)

// Creates or fetches a Core Data Place entity.
+ (Place *)placeWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Place *place                           = nil;
    
    // Build fetch request.
    NSFetchRequest *request                = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.predicate                      = [NSPredicate predicateWithFormat:@"name = %@",name];
    NSSortDescriptor *sortDescriptor       = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors                = [NSArray arrayWithObject:sortDescriptor];
    
    // Execute fetch requesst.
    NSError *error  = nil;
    NSArray *places = [context executeFetchRequest:request error:&error];
    
    if ([places count] > 1) {
        NSLog(@"Error creating Place -- duplicate entries.");
    } else if ([places count] == 0) {
        place      = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
        place.name = name;
    } else {
        place   = [places lastObject];
    }
    
    return place;
}

@end
