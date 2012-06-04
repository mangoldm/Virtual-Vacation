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
    NSFetchRequest *request          = [NSFetchRequest fetchRequestWithEntityName:@"Vacation"];
    request.predicate                = [NSPredicate predicateWithFormat:@"name = %@",name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors          = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error     = nil;
    NSArray *vacations = [context executeFetchRequest:request error:&error];
    
    if (!vacations || ([vacations count] > 1)) {
        NSLog(@"Error finding vacation.");
    } else if (![vacations count]) {
        vacation      = [NSEntityDescription insertNewObjectForEntityForName:@"Vacation" inManagedObjectContext:context];
        vacation.name = name;
    } else {
        vacation = [vacations lastObject];
    }
    
    return vacation;
}

//// Get the Vacations on file.
//+ (NSArray *)vacationsOnFile
//{
//    // Identify the documents folder URL.
//    NSFileManager *fileManager = [[NSFileManager alloc] init];
//    NSError *error             = nil;
//    NSURL *documentsURL        = [fileManager URLForDirectory:NSDocumentDirectory
//                                                     inDomain:NSUserDomainMask
//                                            appropriateForURL:nil
//                                                       create:NO
//                                                        error:&error];
//    if (documentsURL == nil) {
//        NSLog(@"Could not access documents directory\n%@", [error localizedDescription]);
//    }
//    
//    error              = nil;
//    NSArray *keys      = [NSArray arrayWithObjects:NSURLNameKey, NSURLTypeIdentifierKey, nil];
//    NSArray *vacations = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:documentsURL 
//                                                       includingPropertiesForKeys:keys
//                                                                          options:0
//                                                                            error:&error];
//    return vacations;
//}

@end
