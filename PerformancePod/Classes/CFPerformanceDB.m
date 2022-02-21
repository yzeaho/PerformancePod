//
//  CFPerformanceDB.m
//  PerformancePod
//
//  Created by 大帅哥小y on 2022/2/21.
//

#import "CFPerformanceDB.h"
#import <FMDB/FMDB.h>

@interface CFPerformanceDB ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation CFPerformanceDB

- (void)open
{
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self DBPath]];
    [self createTable];
}

@end
