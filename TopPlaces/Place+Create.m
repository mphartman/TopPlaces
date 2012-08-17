//
//  Place+Create.m
//  TopPlaces
//
//  Created by Hartman on 8/16/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "Place+Create.h"

@implementation Place (Create)

+ (Place *)placeWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Place *place = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Place"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || [matches count] > 1) {
        // handle error
    }
    else if ([matches count] == 0) {
        place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
        place.name = name;
    }
    else {
        place = [matches lastObject];
    }
    
    return place;
}

@end
