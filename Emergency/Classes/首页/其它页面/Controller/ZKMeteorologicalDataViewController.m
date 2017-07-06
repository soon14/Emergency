//
//  ZKMeteorologicalDataViewController.m
//  Emergency
//
//  Created by 王小腊 on 2017/7/4.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKMeteorologicalDataViewController.h"
#import "ZKRegionSelectViewController.h"
#import "ZKMeteorologicalTableViewCell.h"
#import "ZKLocation.h"
#import "UIButton+ImageTitleStyle.h"
#import "ZKBasicDataTool.h"
#import "ZKMeteorologicalESRootClass.h"
#import "ZKWeatherMode.h"

@interface ZKMeteorologicalDataViewController ()<UITableViewDelegate, UITableViewDataSource,ZKLocationDelegate>
// 定位工具
@property (strong, nonatomic) ZKLocation *location;

@property (weak, nonatomic) IBOutlet UIView *selectButtonViewLayer;
// 选择按钮
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectButtonHeight;
// 天气图片
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
//温度
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
// 天气状况
@property (weak, nonatomic) IBOutlet UILabel *weatherStateLabel;
// 综合天气
@property (weak, nonatomic) IBOutlet UILabel *comprehensiveWeatherLabel;
@property (weak, nonatomic) IBOutlet UITableView *weatherTableView;
@property (weak, nonatomic) IBOutlet UILabel *abnormalView;
// 城市数据
@property (nonatomic, strong) NSMutableArray <ZKWeatherMode*>* cityArray;
// 天气数据
@property (nonatomic, strong) ZKMeteorologicalESRootClass *rootClass;
@property (assign, nonatomic) BOOL dayState;//白天 黑夜
@property (nonatomic, strong) NSArray *timerArray;// 时间数组
@property (nonatomic, strong) NSMutableDictionary *parameter;
@end

@implementation ZKMeteorologicalDataViewController
#pragma mark  ----懒加载区域----
- (NSMutableDictionary *)parameter
{
    if (!_parameter)
    {
        _parameter = [NSMutableDictionary dictionary];
    }
    return _parameter;
}

- (NSMutableArray<ZKWeatherMode *> *)cityArray
{
    if (!_cityArray)
    {
        _cityArray = [NSMutableArray array];
    }
    return _cityArray;
}
- (ZKLocation *)location
{
    if (!_location)
    {
        _location = [[ZKLocation alloc] init];
        _location.delegate = self;
    }
    return _location;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"气象数据";
    [self setUIview];
    [self setData];
    if (self.resourcecode.length  == 0)
    {
         [self requestCitydata];
    }
    else
    {
        self.selectButtonHeight.constant = 0.0f;
        self.selectButton.hidden = YES;
        [self requestWeatherDataIsCity:NO searchKey:self.resourcecode];
    }
    
}
#pragma mark  ----设置----
- (void)setUIview
{
    self.selectButtonViewLayer.layer.cornerRadius = 14.0f;
    self.selectButtonViewLayer.layer.borderColor = [UIColor orangeColor].CGColor;
    self.selectButtonViewLayer.layer.borderWidth = 0.5;
    
    self.abnormalView.layer.cornerRadius = 4;
    self.abnormalView.layer.borderColor = CYBColorGreen.CGColor;
    self.abnormalView.layer.borderWidth = 0.5;
    // 图片与字的间隔
    [self.selectButton setButtonImageTitleStyle:ButtonImageTitleStyleLeft padding:6];
    
    _weatherTableView.backgroundColor = [UIColor whiteColor];
    _weatherTableView.delegate   = self;
    _weatherTableView.dataSource = self;
    _weatherTableView.tableFooterView = [[UIView alloc] init];
    _weatherTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_weatherTableView registerNib:[UINib nibWithNibName:@"ZKMeteorologicalTableViewCell" bundle:nil] forCellReuseIdentifier:ZKMeteorologicalTableViewCellID];
}

#pragma mark 数据请求
/**
 *  城市天气
 */
-(void)requestCitydata
{
    YJWeakSelf
    [weakSelf.cityArray removeAllObjects];
    hudShowLoading(@"城市数据加载中...");
    [[ZKBasicDataTool sharedManager] obtainCityOne:^(NSArray *cityOne) {
        weakSelf.cityArray = [ZKWeatherMode mj_objectArrayWithKeyValuesArray:cityOne];
        if (weakSelf.cityArray.count > 0)
        {
            [weakSelf locan];
        }
        else
        {
            hudDismiss();
            [UIView addMJNotifierWithText:@"数据异常，请稍后再试！" dismissAutomatically:YES];
        }
        
    }];
}

/**
 请求天气数据
 
 @param isCity 是否请求城市数据
 @param key 搜索值
 */
- (void)requestWeatherDataIsCity:(BOOL)isCity searchKey:(NSString *)key
{
    [self.parameter removeAllObjects];
    [self.parameter setValue:key forKey:isCity?@"code":@"resourcecode"];
    self.abnormalView.hidden = self.rootClass.weather.count != 0;
    YJWeakSelf
    hudShowLoading(@"正在请求天气数据");
    [ZKPostHttp post:@"appWeather/weatherSeven" params:self.parameter success:^(id responseObj) {
        hudDismiss();
        NSString *state = [responseObj valueForKey:@"state"];
        if ([state isEqualToString:@"success"])
        {
            weakSelf.rootClass = [ZKMeteorologicalESRootClass mj_objectWithKeyValues:[responseObj valueForKey:@"data"]];
        }
        else
        {
            [UIView addMJNotifierWithText:@"数据异常，请稍后再试！" dismissAutomatically:YES];
        }
        [weakSelf reloadWeatherData];
        
    } failure:^(NSError *error)
     {
         hudDismiss();
         [weakSelf reloadWeatherData];
         [UIView addMJNotifierWithText:@"网络异常！请查看网络设置。" dismissAutomatically:YES];
     }];
}

/**
 刷新界面数据
 */
- (void)reloadWeatherData
{
    NSString *name = self.rootClass.scency.length == 0?self.rootClass.district:self.rootClass.scency;
    
    [self.selectButton setTitle:name forState:UIControlStateNormal];
    [self.selectButton setButtonImageTitleStyle:ButtonImageTitleStyleLeft padding:6];
    
    self.abnormalView.hidden = self.rootClass.weather.count != 0;
    [self.weatherTableView reloadData];
    
    if (self.rootClass.weather.count >0 )
    {
        // 第一个天气数据数据
        ZKMeteorologicalWeather *list = self.rootClass.weather.firstObject;
        
        [ZKUtil downloadImage:self.weatherImageView imageUrl:self.dayState?list.pic_d:list.pic_n duImageName:@"noData"];
        self.weatherStateLabel.text = self.dayState?list.txt_d:list.txt_n;
        self.temperatureLabel.text =[NSString stringWithFormat:@"%@°C", list.max];
        self.comprehensiveWeatherLabel.text =[NSString stringWithFormat:@"%@°C-%@°C  %@",list.max,list.min,list.wind];
    }
    else
    {
        self.weatherStateLabel.text = @"";
        self.weatherImageView.image = [UIImage imageNamed:@"noData"];
        self.temperatureLabel.text = @"";
        self.comprehensiveWeatherLabel.text = @"";
    }
    
}
#pragma mark  ----ZKLocationDelegate----
- (void)locationDidEndUpdatingLocation:(Location *)location;
{
    [self queryCityWeatherCityName:location.locality];
}
/**
 定位异常
 */
- (void)locationDidFailWithError;
{
    hudDismiss();
    [UIView addMJNotifierWithText:@"定位异常" dismissAutomatically:YES];
}
#pragma mark  ----按钮点击----
- (IBAction)selectButtonClick:(UIButton *)sender
{
    ZKRegionSelectViewController *vc = [[ZKRegionSelectViewController alloc] init];
    vc.locationName = self.selectButton.titleLabel.text;
    YJWeakSelf
    [vc setSelectData:^(NSString *code, BOOL isCity) {
        [weakSelf requestWeatherDataIsCity:isCity searchKey:code];
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark  ----逻辑区域----
// 定位
- (void)locan
{
    hudShowLoading(@"正在定位...");
    [self.location beginUpdatingLocation];
}
// 设置时间数组
- (void)setData
{
    //获取当前时间
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents * dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger hour = [dateComponent hour];
    
    if (hour > 8 && hour < 18) {
        
        self.dayState = YES;
        
    }else{
        
        self.dayState = NO;
    }
    self.timerArray = [self latelyEightTime];
}
//获取最近几天时间 数组
-(NSArray *)latelyEightTime
{
    NSMutableArray *eightArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 7; i ++) {
        //从现在开始的24小时
        NSTimeInterval secondsPerDay = i * 24*60*60;
        NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];               NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];         [dateFormatter setDateFormat:@"M月d日"];         NSString *dateStr = [dateFormatter stringFromDate:curDate];
        //几月几号
        NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];         [weekFormatter setDateFormat:@"EEEE"];
        //星期几 @"HH:mm 'on' EEEE MMMM d"];
        NSString *weekStr = [weekFormatter stringFromDate:curDate];
        
        if (i == 0) {
            weekStr = @"今天";
        }
        //组合时间
        NSString *strTime = [NSString stringWithFormat:@"%@ (%@)",weekStr,dateStr];          [eightArr addObject:strTime];
    }
    return eightArr;
}

/**
 查询城市编码
 
 @param name 地方
 */
- (void)queryCityWeatherCityName:(NSString*)name
{
    __block ZKWeatherMode *mode;
    if ([name containsString:APPNAME])
    {
        [self.cityArray enumerateObjectsUsingBlock:^(ZKWeatherMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([name containsString:obj.cityname])
            {
                mode = obj;
            }
        }];
    }
    else
    {
        mode = self.cityArray.firstObject;
    }
    if (mode)
    {
        [self.selectButton setTitle:mode.cityname forState:UIControlStateNormal];
        [self requestWeatherDataIsCity:YES searchKey:mode.region];
    }
    else
    {
        hudDismiss();
        [UIView addMJNotifierWithText:@"数据异常！" dismissAutomatically:YES];
    }
}
#pragma mark  ----UITableViewDelegate----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rootClass.weather.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKMeteorologicalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZKMeteorologicalTableViewCellID];
    
    if (self.rootClass.weather.count > indexPath.row)
    {
        ZKMeteorologicalWeather *mode = [self.rootClass.weather objectAtIndex:indexPath.row];
        [cell assignmentData:mode date:[self.timerArray objectAtIndex:indexPath.row] dayState:self.dayState cellIndex:indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
