//
//  VacationHelper.m
//  Virtual Vacation
//
//  Created by Michael Mangold on 5/26/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//

#import "VacationHelper.h"

@interface VacationHelper ()
@property UIManagedDocument *document;
@end

@implementation VacationHelper

@synthesize document = _document;

+ (void)openVacationWithName:(NSString *)vacationName
                  usingBlock:(completion_block_t)completionBlock;
{
    NSLog(@"Opening Vacation Document");
    
    // Get documents directory and path.
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url        = [url URLByAppendingPathComponent:vacationName];
    
    // Create the document and open if a match exists on file.
    UIManagedDocument *vacationDocument = [[UIManagedDocument alloc] initWithFileURL:url];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        NSLog(@"vacationDocument.documentState:%i", vacationDocument.documentState);
        [vacationDocument openWithCompletionHandler:^(BOOL success) {
            if (success) NSLog(@"Document was opened.");
            else NSLog (@"Couldn't open document at %@", url);
        }]; } else {
            
            // No match exists, so save the document to file.
            [vacationDocument saveToURL:url forSaveOperation:UIDocumentSaveForCreating
                      completionHandler:^(BOOL success) {
                          if (success) NSLog(@"Document was created.");
                          else NSLog(@"Couldn't create document at %@", url);
                      }]; }
}

@end
