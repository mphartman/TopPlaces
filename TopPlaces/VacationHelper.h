//
//  VacationHelper.h
//  TopPlaces
//
//  Created by Hartman on 8/11/12.
//  Copyright (c) 2012 Piwiggi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^completion_block_t)(UIManagedDocument *vacation);

@interface VacationHelper : NSObject

+ (NSArray *)vacationNameList;

+ (void)openVacation:(NSString *)vacationName
          usingBlock:(completion_block_t)completionBlock;

@end
