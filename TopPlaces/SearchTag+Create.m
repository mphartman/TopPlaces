//
//  SearchTag+Create.m
//  TopPlaces
//
//  Created by Hartman on 8/16/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "SearchTag+Create.h"

@implementation SearchTag (Create)

+ (SearchTag *)searchTagWithName:(NSString *)name inManagedContext:(NSManagedObjectContext *)context
{
    if ([name rangeOfString:@":"].location != NSNotFound) {
        // reject names that contain colon (:)
        return nil;
    }
    
    SearchTag *tag = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SearchTag"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || [matches count] > 1) {
        // handle error
    }
    else if ([matches count] == 0) {
        tag = [NSEntityDescription insertNewObjectForEntityForName:@"SearchTag" inManagedObjectContext:context];
        tag.name = name;
    }
    else {
        tag = [matches lastObject];
    }
    
    return tag;
}

@end
