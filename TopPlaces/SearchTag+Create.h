//
//  SearchTag+Create.h
//  TopPlaces
//
//  Created by Hartman on 8/16/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "SearchTag.h"

@interface SearchTag (Create)

+ (SearchTag *)searchTagWithName:(NSString *)name inManagedContext:(NSManagedObjectContext *)context;

@end
