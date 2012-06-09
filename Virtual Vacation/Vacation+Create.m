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
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Vacation" inManagedObjectContext:context];
    Vacation *vacation                     = [[Vacation alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    
    // Build the fetch request.
    NSFetchRequest *request                = [NSFetchRequest fetchRequestWithEntityName:@"Vacation"];
    request.predicate                      = [NSPredicate predicateWithFormat:@"name = %@",name];
    NSSortDescriptor *sortDescriptor       = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors                = [NSArray arrayWithObject:sortDescriptor];
    
    // Execute the fetch request.
    NSError *error     = nil;
    NSArray *vacations = [context executeFetchRequest:request error:&error];
    NSLog(@"[vacations count]:%i",[vacations count]);
    NSLog(@"context:%@",context);
    if (!vacations || ([vacations count] > 1)) {
        NSLog(@"Error finding vacation.");
    } else if (![vacations count]) {
        vacation.name = name;
        NSLog(@"Vacation created:%@",vacation.name);
    } else {
        vacation = [vacations lastObject];
        NSLog(@"Vacation retrieved:%@",vacation.name);
    }
    
    return vacation;
}

@end
