//
//  ImageCache.m
//  TopPlaces
//
//  Created by Hartman on 8/3/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "ImageCache.h"

#define MAX_CACHE_SIZE_IN_BYTES 10 * 1024 * 1024 // 10 megabytes

@interface ImageCache()
@property (nonatomic, strong) NSURL *cacheDirectory;
@end

@implementation ImageCache

@synthesize cacheDirectory = _cacheDirectory;

- (NSURL *)cacheDirectory
{
    if (!_cacheDirectory) {
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSURL *cachesDirectory = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] objectAtIndex:0];
        _cacheDirectory = [cachesDirectory URLByAppendingPathComponent:@"Images"];
        [fileManager createDirectoryAtURL:_cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return _cacheDirectory;
}

- (long)sizeOfCache
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSArray *files = [fileManager contentsOfDirectoryAtURL:self.cacheDirectory includingPropertiesForKeys:[NSArray arrayWithObject:NSURLTotalFileSizeKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    long totalSize = 0;
    for (NSURL *file in files) {
        NSNumber *filesize;
        [file getResourceValue:&filesize forKey:NSURLTotalFileSizeKey error:nil];
        totalSize += [filesize longValue];
    }
    return totalSize;
}

// deletes the oldest file from the cache
- (void)evictOldestFromCache
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSArray *files = [fileManager contentsOfDirectoryAtURL:self.cacheDirectory includingPropertiesForKeys:[NSArray arrayWithObject:NSURLCreationDateKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];

    NSURL *oldest;
    for (NSURL *file in files) {
        if (!oldest) {
            oldest = file;
        }
        else {
            NSDate *creationDate;
            [file getResourceValue:&creationDate forKey:NSURLCreationDateKey error:nil];
            
            NSDate *oldestDate;
            [oldest getResourceValue:&oldestDate forKey:NSURLCreationDateKey error:nil];

            if ([creationDate compare:oldestDate] == NSOrderedAscending) {
                // file is older than the oldest seen thus far making it the new oldest
                oldest = file;
            }
        }
    }
    
    NSLog(@"Evicting oldest file %@", oldest.path);
    [fileManager removeItemAtURL:oldest error:nil];
}

// reduce the size of the cache until it is below the max threshold
- (void)checkCacheOverflow
{
    while ([self sizeOfCache] > MAX_CACHE_SIZE_IN_BYTES) {
        [self evictOldestFromCache];
    }
}

- (NSData *)dataFromCacheForKey:(NSString *)key
{
    NSURL *imageUrl = [self.cacheDirectory URLByAppendingPathComponent:key];
    return [NSData dataWithContentsOfURL:imageUrl];
}

- (void)addDataToCache:(NSData *)data forKey:(NSString *)key
{
    NSURL *imageFile = [self.cacheDirectory URLByAppendingPathComponent:key];
    [data writeToURL:imageFile atomically:YES];
    [self checkCacheOverflow];
}

@end
