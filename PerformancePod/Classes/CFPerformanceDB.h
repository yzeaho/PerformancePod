#import <Foundation/Foundation.h>
#import "CFPerformanceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CFPerformanceDB : NSObject

- (void)open;

- (void)insert:(NSString *)tag time:(NSInteger)time;

- (void)clear;

- (NSArray<CFPerformanceModel *> *)query;

@end

NS_ASSUME_NONNULL_END
