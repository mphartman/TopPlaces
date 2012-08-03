//
//  ImageCache.h
//  TopPlaces
//
//  Created by Hartman on 8/3/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject

- (NSData *)dataFromCacheForKey:(NSString *)key;

- (void)addDataToCache:(NSData *)data forKey:(NSString *)key;

@end
