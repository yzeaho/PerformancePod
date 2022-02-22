#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFPerformanceModel : NSObject

@property (nonatomic, strong) NSString *tag;
@property (nonatomic, assign) NSInteger maxTime;
@property (nonatomic, assign) NSInteger minTime;
@property (nonatomic, assign) NSInteger avgTime;

@end

NS_ASSUME_NONNULL_END
