//
//  Vacation+Create.m
//  Virtual Vacation
//
//  Created by Michael Mangold on 5/28/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//

#import "Vacation+Create.h"
#import "Vacation.h"

@implementation Vacation (Create)

+ (Vacation *)vacationWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Vacation *vacation               = nil;
    NSLog(@"name:%@",name);
    // Build the fetch request.
    NSFetchRequest *request          = [NSFetchRequest fetchRequestWithEntityName:@"Vacation"];
    request.predicate                = [NSPredicate predicateWithFormat:@"name = %@",name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors          = [NSArray arrayWithObject:sortDescriptor];
    
    // Execute the fetch request.
    NSError *error     = nil;
    NSArray *vacations = [context executeFetchRequest:request error:&error];
    
    if (!vacations){
        NSLog(@"Error finding vacation - nil.");
    } else if ([vacations count] > 1) {
        NSLog(@"Error finding vacation - duplicate.");
    } else if ([vacations count] == 0) {
        NSLog(@"Creating vacation.");
        vacation      = [NSEntityDescription insertNewObjectForEntityForName:@"Vacation" inManagedObjectContext:context];
        vacation.name = name;
    } else {
        NSLog(@"Retrieving vacation.");
        vacation = [vacations lastObject];
    }
    
    return vacation;
}

@end
