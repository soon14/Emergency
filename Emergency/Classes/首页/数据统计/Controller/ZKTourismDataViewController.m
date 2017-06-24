//
//  ZKTourismDataViewController.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/24.
//  Copyright © 2017年 王小腊. All rights reserved.
//

NSString *const tourismCellIIdentifier = @"tourismCellIIdentifier";

#import "ZKTourismDataViewController.h"
#import "ZKElectronicLtineraryViewController.h"
#import "TBTaskSearchView.h"
#import "ZKTourismDataTeamCell.h"
#import "ZKTourismDataBusCell.h"
#import "UIBarButtonItem+Custom.h"

@interface ZKTourismDataViewController ()
// 计时器
@property (nonatomic, strong) NSTimer          *timer;
@property (nonatomic, strong) NSDateFormatter  *formatter;
// 进度条
@property (nonatomic, strong) UIProgressView   *progressView;
@property (nonatomic, strong) UILabel          *timeLabel;
@property (nonatomic, strong) UILabel          *headerNameLanel;
@property (nonatomic, strong) TBTaskSearchView *searchView;
// 是否新加数据
@property (nonatomic, assign) BOOL             noNewAddData;
@end

@implementation ZKTourismDataViewController

- (NSTimer *)timer
{
    if (!_timer)
    {
        _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progressUpdate) userInfo:nil repeats:YES];
    }
    return _timer;
}
- (NSDateFormatter *)formatter
{
    if (!_formatter)
    {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    }
    return _formatter;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.timer fire];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark  ----UITableView----

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tourismCellIIdentifier];
    if (self.roots.count > indexPath.row)
    {
        if (self.tourismDataType == TourismDataTypeTeam)
        {
            [(ZKTourismDataTeamCell *)cell assignmentCellData:[self.roots objectAtIndex:indexPath.row]];
        }
        else
        {
            [(ZKTourismDataBusCell *)cell assignmentCellData:[self.roots objectAtIndex:indexPath.row]];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tourismDataType == TourismDataTypeTeam)
    {
        ZKElectronicLtineraryViewController *vc = [[ZKElectronicLtineraryViewController alloc] init];
        vc.list = [self.roots objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {

    }

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark  ----super 方法----
- (void)initData;
{
    if (self.tourismDataType == TourismDataTypeTeam)
    {
        self.navigationItem.title = @"旅游团队";
        self.postUrl = @"appTours/toursList";
        self.modeClass = [ZKTourismDataTeamMode class];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZKTourismDataTeamCell class]) bundle:nil] forCellReuseIdentifier:tourismCellIIdentifier];
    }
    else
    {
        self.navigationItem.title = @"旅游大巴";
        self.postUrl = @"appBus/busList";
        self.modeClass = [ZKTourismDataBusMode class];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZKTourismDataBusCell class]) bundle:nil] forCellReuseIdentifier:tourismCellIIdentifier];
        if (self.tourismDataType == TourismDataTypeBusShowMapBuuton)
        {
            [self addRightBarButtonItem];
        }
    }
    
    [super initData];
}
- (void)setUpView;
{
    [super setUpView];
    [self createHeaderView];
}
/**
 原生数据
 
 @param dictionary 数据
 */
- (void)originalData:(NSDictionary *)dictionary;
{
    if (self.noNewAddData == NO)
    {
        NSNumber *total =[dictionary valueForKey:@"total"];
        total = [total isKindOfClass:[NSNumber class]]?total:[NSNumber numberWithInt:0];
        if (self.tourismDataType == TourismDataTypeTeam)
        {
            self.headerNameLanel.text =[NSString stringWithFormat:@"%@正在运行的旅游团队:%@个",APPNAME,total];
        }
        else
        {
            self.headerNameLanel.text =[NSString stringWithFormat:@"%@正在运行旅游大巴总数:%@辆",APPNAME,total];
        }
        self.noNewAddData = YES;
    }
}
- (void)endDataRequest;//数据请求结束
{
    
}
#pragma mark  ----创建头部视图----
- (void)createHeaderView
{
    // 头部窗口创建
    UIView *headerconterView = [[UIView alloc] init];
    headerconterView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerconterView];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor grayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    [headerconterView addSubview:self.timeLabel];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.progress  = 0.3f;
    self.progressView.progressTintColor = [UIColor orangeColor];
    self.progressView.trackTintColor = [UIColor grayColor];
    [headerconterView addSubview:self.progressView];
    
    self.headerNameLanel = [[UILabel alloc] init];
    self.headerNameLanel.textColor = [UIColor whiteColor];
    self.headerNameLanel.backgroundColor = [UIColor orangeColor];
    self.headerNameLanel.layer.masksToBounds = YES;
    self.headerNameLanel.layer.cornerRadius = 17;
    self.headerNameLanel.textAlignment = NSTextAlignmentCenter;
    self.headerNameLanel.font = [UIFont systemFontOfSize:18 weight:0.2];
    self.headerNameLanel.text = @"数据未加载...";
    [headerconterView addSubview:self.headerNameLanel];
    
    self.searchView = [[TBTaskSearchView alloc] init];
    [self.view addSubview:self.searchView];
    
    YJWeakSelf
    // 搜索数据
    [self.searchView setSearchResult:^(NSString *key) {
        
        [weakSelf.parameter setObject:key forKey:@"tname"];
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
    [headerconterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.view);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerconterView.mas_right).offset(-16);
        make.top.equalTo(headerconterView.mas_top);
        make.height.equalTo(@30);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.timeLabel.mas_right);
        make.top.equalTo(weakSelf.timeLabel.mas_bottom);
        make.width.equalTo(@140);
    }];
    [self.headerNameLanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerconterView.mas_left).offset(16);
        make.right.equalTo(headerconterView.mas_right).offset(-16);
        make.top.equalTo(weakSelf.progressView.mas_bottom).offset(8);
        make.bottom.equalTo(headerconterView.mas_bottom).offset(-8);
        make.height.equalTo(@34);
    }];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(16);
        make.right.equalTo(weakSelf.view.mas_right).offset(-16);
        make.top.equalTo(headerconterView.mas_bottom).offset(10);
        make.height.equalTo(@40);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.searchView.mas_bottom).offset(10);
    }];
}
/**
 添加地图跳转按钮
 */
- (void)addRightBarButtonItem
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem setRitWithTitel:@"" itemWithIcon:@"itemMap" target:self action:@selector(goMap)];
}
#pragma mark  ----事件----
- (void)progressUpdate
{
    NSDate *now = [NSDate date];
    // 设置格式
    [self.formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    // 格式化日期
    NSString *string = [self.formatter stringFromDate:now];
    self.timeLabel.text =string;
    // 进度计算
    [self.formatter setDateFormat:@"s"];
    double number = [[self.formatter stringFromDate:now] doubleValue]/60;
    self.progressView.progress = number;
}
- (void)goMap
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
