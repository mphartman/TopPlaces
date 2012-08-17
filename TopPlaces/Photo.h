//
//  Photo.h
//  TopPlaces
//
//  Created by Hartman on 8/11/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) Place *whereTaken;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addTagsObject:(NSManagedObject *)value;
- (void)removeTagsObject:(NSManagedObject *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
