//
//  ZKElectronicMapViewController.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/27.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKElectronicMapViewController.h"
#import "ZKResourceStatViewController.h"
#import "ZKTourismDataViewController.h"
#import "ZKMapChooseView.h"
#import "ZKMapRollingView.h"
#import "TBTaskSearchView.h"
#import "ZKTypeSelectionView.h"
#import "TMapView.h"
#import "ZKMapTAnnotationView.h"
#import "ZKElectronicMapViewMode.h"
#import "ZKElectronicMapAnnotation.h"
#import "ZKBaseClassViewMode.h"

@interface ZKElectronicMapViewController ()<TMapViewDelegate,ZKMapChooseViewDelegate,ZKTypeSelectionViewDelegate,ZKBaseClassViewModeDelegate,ZKMapRollingViewDelegate>

@property (nonatomic, strong) TMapView *mapView;
//搜索框
@property (nonatomic, strong) TBTaskSearchView *searchView;
//条件按钮
@property (nonatomic, strong) ZKMapChooseView *chooseView;
// 滚动视图
@property (nonatomic, strong) ZKMapRollingView *rollingView;
// 数据模型
@property (nonatomic, strong) ZKBaseClassViewMode *viewMode;
// 搜索值
@property (nonatomic, strong) NSString *searchValue;
// 等级显示字段
@property (nonatomic, strong) NSString *levelName;
// 参数level值
@property (nonatomic, strong) NSString *level;
// 地区值显示字段
@property (nonatomic, strong) NSString *regionName;
// 地区值
@property (nonatomic, strong) NSString *region;
// 搜索关键字
@property (nonatomic, strong) NSString *searchKey;
// 显示类型
@property (nonatomic) ElectronicMapType electronicMapType;
// 是否跳向busController
@property (nonatomic, assign) BOOL isPushBusController;
// 请求参数
@property (nonatomic, strong) NSMutableDictionary *parameter;

@property (nonatomic, strong) NSMutableArray <ZKElectronicMapViewMode *>*dataArray;
@end

@implementation ZKElectronicMapViewController
- (NSMutableArray<ZKElectronicMapViewMode *> *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (ZKBaseClassViewMode *)viewMode
{
    if (!_viewMode)
    {
        _viewMode = [[ZKBaseClassViewMode alloc] init];
        _viewMode.delegate = self;
    }
    return _viewMode;
}
- (NSMutableDictionary *)parameter
{
    if (!_parameter)
    {
        _parameter = [NSMutableDictionary dictionary];
    }
    return _parameter;
}
#pragma mark  ----TMapViewDelegate----
/**
 * 视图区域即将改变，在改变区域之前调用
 * @param mapView   [in] : 地图视图
 * @param animated  [in] : 是否以动画的方式改变
 */
- (void)mapView:(TMapView *)mapView regionWillChangeAnimated:(BOOL)animated;
{
    [self.view endEditing:YES];
}
/**
 * 用户实现创建一个动态标注视图
 * @param mapView    [in] : 图视图
 * @param annotation [in] : 动态标注
 * @return 生成的动态标注视图
 */
- (TAnnotationView *)mapView:(TMapView *)mapView viewForAnnotation:(id <TAnnotation>)annotation
{
    if (self.dataArray.count > 0)
    {
        // 数据源
        ZKElectronicMapAnnotation *mode = (ZKElectronicMapAnnotation *)annotation;
        static NSString *cellIdentifier = @"cellIdentifier";
        ZKMapTAnnotationView *annotationView = [[ZKMapTAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:cellIdentifier];
        annotationView.image = [UIImage imageNamed:@"annont_0"];
        annotationView.selectImage = [UIImage imageNamed:@"annont_1"];
        annotationView.canShowCallout = NO;
        [annotationView createLabelName:mode.annotationTag];
        
        return annotationView;
    }
    
    return nil;
}
/**
 * 当一个动态标注被选中时,系统调用
 * @param mapView   [in] : 地图视图
 * @param view      [in] : 点击的动态标注的视图
 */
- (void)mapView:(TMapView *)mapView didSelectAnnotationView:(TAnnotationView *)view
{
    // 选中滚动视图
    ZKMapTAnnotationView *annotationView = (ZKMapTAnnotationView *)view;
    [self.rollingView selectedCurrentItemIndex:annotationView.annotationTag];
    [self.mapView setCenterCoordinate:annotationView.annotation.coordinate animated:YES];
    // 取消其它选中状态的气泡
    NSArray *arrSelect = mapView.selectedAnnotations;
    [arrSelect enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        id <TAnnotation> ann = obj;
        if (ann != view.annotation) {
            [mapView deselectAnnotation:ann animated:YES];
        }
    }];
}
#pragma mark  ----ZKMapRollingViewDelegate----
/**
 滚动视图
 
 @param index 结束后的第几个
 @param type 数据类型
 */
- (void)rollingDidEndScrollingCurrentItemIndex:(NSInteger)index dataType:(RollingViewType)type;
{
    if (index < self.mapView.annotations.count)
    {
        ZKElectronicMapAnnotation *annotation = [self.mapView.annotations objectAtIndex:index];
        [self.mapView selectAnnotation:annotation animated:NO];
        
    }
}
/**
 列表按钮点击
 
 @param type 类型
 */
- (void)rollingListButtonClickType:(RollingViewType)type;
{
    self.isPushBusController = type == RollingViewTypeBus;
    if (type == RollingViewTypeBus)
    {
        ZKTourismDataViewController *vc = [[ZKTourismDataViewController alloc] init];
        vc.tourismDataType = TourismDataTypeBusNone;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        NSDictionary *dic = @{@"left":self.regionName,@"region":self.region, @"right":self.levelName,@"level":self.level};
        ZKResourceStatViewController *vc = [[ZKResourceStatViewController alloc] init];
        [vc configurationDataSearchType:(NSInteger)type buttonDefaultData:dic isMap:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark  ----ZKMapChooseViewDelegate----
/**
 搜索回调
 
 @param key 搜索字段
 */
- (void)searchResultString:(NSString *)key;
{
    self.searchValue = key;
    [self requestData];
}
/**
 选择数据后的回调
 
 @param data 数据
 @param type 是否左边按钮选择的
 */
- (void)resourceSelectedData:(NSDictionary *)data selectedButtonType:(SelectedButtonType)type;
{
    if (type == SelectedButtonTypeLeft)
    {
        self.regionName = [data valueForKey:@"cityname"];
        self.region     = [data valueForKey:@"region"];
        
    }
    else if (type == SelectedButtonTypeRight)
    {
        self.levelName = [data valueForKey:@"slevel"];
        self.level     = [data valueForKey:@"type"];
    }
    [self requestData];
}
#pragma mark  ----ZKTypeSelectionViewDelegate----
/**
 选中结果类型
 
 @param type 类型
 */
-  (void)selectedResultsType:(SelectionDataType)type;
{
    [self reductionConditions];
    self.electronicMapType = (NSInteger)type;
    [self.chooseView resetDataType:(NSInteger)type];
    [self requestData];
}
#pragma mark  ----ZKBaseClassViewModeDelegate----
/**
 请求结束
 
 @param dataArray 数据源
 */
- (void)postDataEnd:(NSArray *)dataArray;
{
    hudDismiss();
    if (dataArray.count != 0)
    {
        NSArray <ZKElectronicMapViewMode *>*data = [ZKElectronicMapViewMode mj_objectArrayWithKeyValuesArray:dataArray];
        YJWeakSelf
        [data enumerateObjectsUsingBlock:^(ZKElectronicMapViewMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.coordinate_x > 0 && obj.coordinate_y > 0) {
                [weakSelf.dataArray addObject:obj];
            }
        }];
        
        [self addMapAnnotationView];
    }
    else
    {
        [UIView addMJNotifierWithText:@"亲！没查询到数据。" dismissAutomatically:YES];
    }
}
/**
 请求出错了
 
 @param error 错误信息
 */
- (void)postError:(NSString *)error;
{
    hudDismiss();
    [UIView addMJNotifierWithText:error dismissAutomatically:YES];
}

#pragma mark  ----数据配置----

/**
 地图配置数据
 
 @param type 资源类型
 @param defaultData 按钮默认值 @{@"left":@"-",@"region":@"-", @"right":@"-",@"level":@"-"}
 */
- (void)mapConfigurationType:(ElectronicMapType)type dataDefaultData:(NSDictionary *)defaultData;
{
    BOOL isData = defaultData.count == 4;
    self.electronicMapType = type;
    // 赋值
    self.levelName = isData? [defaultData valueForKey:@"right"] : @"不限";
    self.level = isData? [defaultData valueForKey:@"level"] : @"";
    self.regionName = isData? [defaultData valueForKey:@"left"] : @"不限";
    self.region = isData? [defaultData valueForKey:@"region"] : @"";
}

/**
 设置参数 配置视图显示
 */
- (void)setUpParameterAndViewFrame
{
    switch (self.electronicMapType)
    {
        case ElectronicMapTypeNone:
            self.viewMode.url = @"appScency/scencyList";
            self.searchKey  = @"name";
            break;
        case ElectronicMapTypeHotel:
            self.viewMode.url = @"appHotel/hotelList";
            self.searchKey  = @"name";
            break;
        case ElectronicMapTypeTravel:
            self.viewMode.url = @"appTravel/travelList";
            self.searchKey  = @"name";
            break;
        case ElectronicMapTypeScenic:
            self.viewMode.url = @"appScency/scencyList";
            self.searchKey  = @"name";
            break;
        case ElectronicMapTypeBus:
            self.viewMode.url = @"appBus/busList";
            self.searchKey  = @"busnum";
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.chooseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.electronicMapType == ElectronicMapTypeBus ? 0.0f:50);
        }];
        [self.chooseView layoutIfNeeded];
    }];
    
    if (self.electronicMapType != ElectronicMapTypeBus)
    {
        [self.parameter setObject:self.level forKey:@"levels"];
        [self.parameter setObject:self.region forKey:@"region"];
    }
    if (self.searchValue)
    {
        [self.parameter setObject:self.searchValue forKey:self.searchKey];
    }
    [self.parameter setObject:@"1" forKey:@"pageNo"];
    [self.parameter setObject:@"50" forKey:@"pageSize"];
    [self.parameter setObject:@"json" forKey:@"format"];
}
#pragma mark  ----数据处理区域----
/**
 设置参数请求数据
 */
- (void)requestData
{
    [self clearData];
    [self setUpParameterAndViewFrame];
    hudShowLoading(@"数据加载中...");
    [self.viewMode postDataParameter:self.parameter];
}

/**
 添加气泡
 */
- (void)addMapAnnotationView
{
    [self.dataArray enumerateObjectsUsingBlock:^(ZKElectronicMapViewMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZKElectronicMapAnnotation *pointAnnotation = [[ZKElectronicMapAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(obj.coordinate_y, obj.coordinate_x);
        pointAnnotation.annotationTag = idx;
        [self.mapView addAnnotation:pointAnnotation];
    }];
    [self.rollingView updataData:self.dataArray dataType:(NSInteger)self.electronicMapType];
    // 拿到第一个数据 选中他
    ZKElectronicMapAnnotation *annotation = self.mapView.annotations.firstObject;
    [self.mapView selectAnnotation:annotation animated:NO];
}


/**
 还原条件参数
 */
- (void)reductionConditions
{
    self.levelName =  @"不限";
    self.level = @"";
    self.regionName =  @"不限";
    self.region = @"";
    self.searchValue = @"";
    [self.searchView empty];
}
/**
 清除数据
 
 */
- (void)clearData;
{
    [self.parameter removeAllObjects];
    [self.dataArray removeAllObjects];
    [self.rollingView updataData:nil dataType:(NSInteger)self.electronicMapType];
    [self removeAnnotations];
}

/**
 清除气泡
 */
- (void)removeAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView setNeedsDisplay];
    if (self.mapView.annotations.count != 0)
    {
        [self removeAnnotations];
    }
}
#pragma mark  ----视图创建----
/**
 创建天地图
 */
- (void)createMapView
{
    self.mapView = [[TMapView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, _SCREEN_HEIGHT - 64)];
    self.mapView.CurentMapType = 0;
    self.mapView.delegate = self;
    [self.mapView setMapScale:8.5 animated:YES];
    [self.view addSubview:self.mapView];
}
/**
 创建其他视图
 */
- (void)createViews
{
    YJWeakSelf
    CGFloat fromAbove = 20.0f;
    if (self.electronicMapType ==  ElectronicMapTypeNone)
    {
        fromAbove = fromAbove + 40.0f;
        ZKTypeSelectionView *selectionView = [[ZKTypeSelectionView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 40)];
        selectionView.delegate = self;
        [selectionView selectType:0];
        [self.mapView insertSubview:selectionView atIndex:1000];
    }
    self.searchView = [[TBTaskSearchView alloc] init];
    [self.searchView setSearchResult:^(NSString *key) {
        // 关键字搜索
        [weakSelf searchResultString:key];
    }];
    [self.mapView insertSubview:self.searchView atIndex:1001];
    
    self.rollingView = [[ZKMapRollingView alloc] init];
    self.rollingView.backgroundColor = [UIColor clearColor];
    self.rollingView.delegate = self;
    // 设置列表按钮是否可以显示
    self.rollingView.showListbutton = self.electronicMapType == ElectronicMapTypeNone ?YES:NO;
    [self.view insertSubview:self.rollingView atIndex:1002];
    
    if (self.electronicMapType != ElectronicMapTypeBus)
    {
        self.chooseView = [ZKMapChooseView mapChooseView];
        self.chooseView.delegate = self;
        // 类型改变
        NSInteger type = self.electronicMapType == ElectronicMapTypeNone ? 3: self.electronicMapType;
        [self.chooseView configurationDataType:type leftTitle:self.regionName rightTitle:self.levelName];
        [self.view insertSubview:self.chooseView atIndex:1003];
        
        [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(weakSelf.view);
            make.height.equalTo(@50);
        }];
        [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.chooseView.mas_top);
        }];
    }
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mapView.mas_left).offset(20);
        make.right.equalTo(weakSelf.mapView.mas_right).offset(-20);
        make.top.equalTo(weakSelf.mapView.mas_top).offset(fromAbove);
        make.height.equalTo(@34);
    }];
    
    [self.rollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        if (self.electronicMapType == ElectronicMapTypeBus)
        {
            make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-10);
        }
        else
        {
            make.bottom.equalTo(weakSelf.chooseView.mas_top).offset(-10);
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createMapView];
    [self createViews];
    [self requestData];
    self.navigationItem.title = @"电子地图";
}
// UIViewController对象的视图即将消失、被覆盖或是隐藏时调用
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
//UIViewController对象的视图即将加入窗口时调用
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isPushBusController == YES)
    {
        /*进入轨迹页面地图重新设置 返回该界面必须重新设置类型和frame 这是个坑*/
        self.mapView.CurentMapType = 0;
        self.mapView.frame = CGRectMake(0, 0, _SCREEN_WIDTH, _SCREEN_HEIGHT - 64);
        YJWeakSelf
        [self.mapView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.chooseView.mas_top);
        }];
    }
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
