#import "CFViewController.h"
#import "CFPerformanceService.h"
#import "CFPerformanceViewController.h"

@interface CFViewController ()

@end

@implementation CFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"CFViewController";
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *key = [NSString stringWithFormat:@"%ld", (long)self.hash];
    [CFPerformanceService start:key];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSString *key = [NSString stringWithFormat:@"%ld", (long)self.hash];
    [CFPerformanceService finish:key tag:@"CFViewController_APPEAR"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CFPerformanceViewController *c = [CFPerformanceViewController new];
    [self.navigationController pushViewController:c animated:YES];
}

@end
