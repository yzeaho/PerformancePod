//
//  CFPerformanceService.m
//  PerformancePod
//
//  Created by 大帅哥小y on 2022/2/21.
//

#import "CFPerformanceService.h"
#import "CFPerformanceDB.h"

@interface CFPerformanceService ()

@property (strong, nonatomic) CFPerformanceDB *db;

@end

@implementation CFPerformanceService

static BOOL g_enable = NO;

+ (void)initialize:(BOOL)enable {
    g_enable = enable;
    [db open];
}

@end
