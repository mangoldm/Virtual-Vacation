//
//  VacationHelper.m
//  Virtual Vacation
//
//  Created by Michael Mangold on 5/26/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//

#import "VacationHelper.h"

@interface VacationHelper ()
@end

@implementation VacationHelper

+ (void)openVacationWithName:(NSString *)vacationName usingBlock:(completion_block_t)completionBlock;
{
    // Get documents directory and path.
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url        = [url URLByAppendingPathComponent:vacationName];
    
    // Create the document and open if a match exists on file.
    UIManagedDocument *vacationDocument = [[UIManagedDocument alloc] initWithFileURL:url];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [vacationDocument openWithCompletionHandler:^(BOOL success) {
            if (!success) NSLog (@"Couldn't open document at %@", url);
        }];
    } else {
        
        // No match exists, so save the document to file.
        [vacationDocument saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (!success) NSLog(@"Couldn't create document at %@", url);
        }];
    }
    completionBlock(vacationDocument);
}

@end
