//
//  VacationHelper.h
//  Virtual Vacation
//
//  Created by Michael Mangold on 5/26/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//
//  A “helper” class that provides a shared UIManagedDocument for a given vacation.
//

#import <UIKit/UIKit.h>

typedef void (^completion_block_t)(UIManagedDocument *vacationDocument);

@interface VacationHelper : NSObject

+ (void)openVacationWithName:(NSString *)vacationName
          usingBlock:(completion_block_t)completionBlock;

@end
