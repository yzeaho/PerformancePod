#import "CFPerformanceService.h"
#import "CFPerformanceDB.h"

@interface CFPerformanceService ()

@end

@implementation CFPerformanceService

static BOOL sEnable = NO;
static CFPerformanceDB *db;
static NSMutableDictionary<NSString *, NSNumber *> *dictionary;
static NSLock *locker;

+ (void)initialize:(BOOL)enable {
    sEnable = enable;
    if (enable) {
        dictionary = [NSMutableDictionary new];
        locker = [NSLock new];
        db = [CFPerformanceDB new];
        [db open];
    }
}

+ (void)clear:(void(^)(void))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [db clear];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    });
}

+ (void)query:(void(^)(NSArray<CFPerformanceModel *> *modelList))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray<CFPerformanceModel *> *r = [db query];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(r);
        });
    });
}

+ (NSString *)start
{
    if (!sEnable) {
        return nil;
    }
    NSString *key = [self randomKey];
    [self start:key];
    return key;
}

+ (void)start:(NSString *)key
{
    if (!sEnable) {
        return;
    }
    [locker lock];
    NSInteger startTime = [[NSDate date] timeIntervalSince1970] * 1000;
    [dictionary setValue:@(startTime) forKey:key];
    [locker unlock];
}

+ (void)finish:(NSString *)key
{
    if (!sEnable) {
        return;
    }
    [self finish:key tag:key];
}

+ (void)finish:(NSString *)key tag:(NSString *)tag
{
    if (!sEnable) {
        return;
    }
    [locker lock];
    NSNumber *value = [dictionary objectForKey:key];
    if (value) {
        [dictionary removeObjectForKey:key];
        NSInteger endTime = [[NSDate date] timeIntervalSince1970] * 1000;
        NSInteger time = endTime - value.longValue;
        [self saveAsync:tag time:time];
    } else {
        NSLog(@"miss %@???", key);
    }
    [locker unlock];
}

+ (void)saveAsync:(NSString *)tag time:(NSInteger)time
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [db insert:tag time:time];
    });
}

+ (NSString *)randomKey
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

@end
