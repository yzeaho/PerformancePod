#import "CFPerformanceDB.h"
#import <FMDB/FMDB.h>

@interface CFPerformanceDB ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation CFPerformanceDB

- (void)open
{
    NSString *dbFile = [self generateDbFile];
    NSLog(@"dbFile:%@", dbFile);
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbFile];
    [self createTable];
}

- (void)insert:(NSString *)tag time:(NSInteger)time
{
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"INSERT INTO performance(tag, time) values(?,?)";
        NSArray *array = @[tag, @(time)];
        [db executeUpdate:sql withArgumentsInArray:array];
    }];
}

- (void)clear
{
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:@"DELETE FROM performance"];
    }];
}

- (NSArray<CFPerformanceModel *> *)query
{
    NSMutableArray<CFPerformanceModel *> *result = [NSMutableArray new];
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = @"SELECT tag, avg(time) as avgTime, max(time) as maxTime, min(time) as minTime FROM performance GROUP BY tag";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            if (rs.resultDictionary) {
                CFPerformanceModel *model = [CFPerformanceModel new];
                [model setValuesForKeysWithDictionary:rs.resultDictionary];
                [result addObject:model];
            }
        }
        [rs close];
    }];
    return result;
}

- (NSString *)generateDbFile
{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docDir stringByAppendingPathComponent:@"CFPerformance.db"];
}

- (void)createTable
{
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS performance(\
            tag         TEXT,\
            time        INTEGER\
        )"];
    }];
}

@end
