//
//  VacationHelper.m
//  TopPlaces
//
//  Created by Hartman on 8/11/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import "VacationHelper.h"

@implementation VacationHelper

+ (NSArray *)vacationNameList
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *url = [[fileManager URLsForDirectory:NSDocumentDirectory
                                      inDomains:NSUserDomainMask] lastObject];
    
    NSArray * files = [fileManager contentsOfDirectoryAtURL:url
                                 includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey]
                                                    options:NSDirectoryEnumerationSkipsHiddenFiles
                                                      error:nil];

    NSMutableArray *names = [NSMutableArray array];
    for (NSURL *file in files) {
        NSString *name;
        [file getResourceValue:&name forKey:NSURLNameKey error:nil];
        [names addObject:name];
    }
    
    return names;
    
}

+ (void)openVacation:(NSString *)vacationName
          usingBlock:(completion_block_t)completionBlock;
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:vacationName];
    // url is now "<Documents Directory>/<vacationName>"
    UIManagedDocument *vacationDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[vacationDatabase.fileURL path]]) {
        // does not exist on disk, so create it
        [vacationDatabase saveToURL:vacationDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (completionBlock) completionBlock(vacationDatabase);
        }];
    }
    else if (vacationDatabase.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        [vacationDatabase openWithCompletionHandler:^(BOOL success) {
            if (completionBlock) completionBlock(vacationDatabase);
        }];
    }
    else if (vacationDatabase.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        if (completionBlock) completionBlock(vacationDatabase);
    }
}

@end
