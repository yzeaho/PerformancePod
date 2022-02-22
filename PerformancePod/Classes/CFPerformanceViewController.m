#import "CFPerformanceViewController.h"
#import "CFPerformanceModel.h"
#import "CFPerformanceService.h"

@interface CFPerformanceViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<CFPerformanceModel *> *dataList;

@end

@implementation CFPerformanceViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self loadData];
}

- (void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
    CGFloat t = self.view.safeAreaInsets.top;
    CGFloat b = self.view.safeAreaInsets.bottom;
    _tableView.frame = CGRectMake(0, t, self.view.frame.size.width, self.view.frame.size.height - t - b);
}

#pragma mark - Private Method

- (void)setupViews
{
    self.title = @"性能统计";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *clearBtn = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(onClickClear)];
    self.navigationItem.rightBarButtonItem = clearBtn;
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 64;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    }
    return _tableView;
}

- (void)loadData
{
    [CFPerformanceService query:^(NSArray<CFPerformanceModel *> * _Nonnull modelList) {
        self.dataList = modelList;
        [self.tableView reloadData];
    }];
}

- (void)onClickClear
{
    [CFPerformanceService clear:^() {
        [self loadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"costCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    CFPerformanceModel *model = self.dataList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", model.tag];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld    MAX:%ld    MIN:%ld", model.avgTime, model.maxTime, model.minTime];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
