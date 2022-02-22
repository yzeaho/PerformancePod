#import <Foundation/Foundation.h>
#import "CFPerformanceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CFPerformanceService : NSObject

+ (void)initialize:(BOOL)enable;

+ (void)clear:(void(^)(void))completion;

+ (NSString *)start;

+ (void)start:(NSString *)key;

+ (void)finish:(NSString *)key;

+ (void)finish:(NSString *)key tag:(NSString *)tag;

+ (void)query:(void(^)(NSArray<CFPerformanceModel *> *modelList))completion;

@end

NS_ASSUME_NONNULL_END
