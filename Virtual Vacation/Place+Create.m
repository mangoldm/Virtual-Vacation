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
    if (!name) name = @"Place Unknown";
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Place" inManagedObjectContext:context];
    Place *place                           = [[Place alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    
    // Build fetch request.
    NSFetchRequest *request                = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.predicate                      = [NSPredicate predicateWithFormat:@"name = %@",name];
    NSSortDescriptor *sortDescriptor       = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors                = [NSArray arrayWithObject:sortDescriptor];
    
    // Execute fetch requesst.
    NSError *error  = nil;
    NSArray *places = [context executeFetchRequest:request error:&error];
    
    if (!places) {
        NSLog(@"Error creating Place -- nil.");
    } else if ([places count] > 1) {
        NSLog(@"Error creating Place -- duplicate entries.");
    } else if ([places count] == 0) {
        place.name = name;
        NSLog(@"Created place %@",place.name);
    } else {
        place   = [places lastObject];
        NSLog(@"Retrieved place %@",place.name);
    }
    
    return place;
}

@end
