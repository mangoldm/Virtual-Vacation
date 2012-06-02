//
//  Vacation+Create.h
//  Virtual Vacation
//
//  Created by Michael Mangold on 5/28/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//

#import "Vacation.h"

@interface Vacation (Create)
+ (Vacation *)vacationWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
@end
