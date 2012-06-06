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
        Place *place1 = [places objectAtIndex:0];
        Place *place2 = [places objectAtIndex:1];
        NSLog(@"Error creating Place -- places1:%@ places2:%@",place1.name, place2.name);
    } else if ([places count] == 0) {
        place      = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
        place.name = name;
        NSLog(@"Created place %@",place.name);
    } else {
        place   = [places lastObject];
        NSLog(@"Retrieved place %@",place.name);
    }
    
    return place;
}

@end
