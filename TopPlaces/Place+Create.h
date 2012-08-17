//
//  Place+Create.h
//  TopPlaces
//
//  Created by Hartman on 8/16/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "Place.h"

@interface Place (Create)

+ (Place *)placeWithName:(NSString *)name
  inManagedObjectContext:(NSManagedObjectContext *)context;

@end
