//
//  ZKBusTrajectoryViewController.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/26.
//  Copyright © 2017年 王小腊. All rights reserved.
//
static NSString *const busCellIdentifier = @"busCellIdentifier";

#import "ZKBusTrajectoryViewController.h"
#import "ZKTourismDataBusMode.h"
#import "ZKBaseClassViewMode.h"
#import "ZKBusTrajectoryMode.h"
#import "TMapView.h"
#import "TPolyline.h"
#import "TPolylineView.h"
#import "TBBusAnnotation.h"
#import "ZKBusTAnnotationView.h"
#import "ZKBusTrajectoryTableViewCell.h"
#import "UIScrollView+EmptyDataSet.h"

@interface ZKBusTrajectoryViewController ()<ZKBaseClassViewModeDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UITableViewDelegate,UITableViewDataSource,TMapViewDelegate>

@property (nonatomic, strong) TMapView *mapView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZKBaseClassViewMode *postMode;
// 所有数据
@property (nonatomic, strong) NSMutableArray <ZKBusTrajectoryMode *>*trajectoryArray;
// 记录数据 筛选后的
@property (nonatomic, strong) NSMutableArray <ZKBusTrajectoryMode *>*recordArray;

@end

@implementation ZKBusTrajectoryViewController

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}
- (ZKBaseClassViewMode *)postMode
{
    if (!_postMode)
    {
        _postMode = [[ZKBaseClassViewMode alloc] init];
        _postMode.delegate = self;
        _postMode.url = @"appBus/buslocusDataList";
    }
    return _postMode;
}
- (NSMutableArray<ZKBusTrajectoryMode *> *)trajectoryArray
{
    if (!_trajectoryArray)
    {
        _trajectoryArray = [NSMutableArray array];
    }
    return _trajectoryArray;
}
- (NSMutableArray<ZKBusTrajectoryMode *> *)recordArray
{
    if (!_recordArray)
    {
        _recordArray = [NSMutableArray array];
    }
    return _recordArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [NSString stringWithFormat:@"%@运行轨迹",self.busMode.busnum];
    
    [self createMapView];
    [self createTableView];
    [self requestTrajectoryData];
}
#pragma mark  ----请求轨迹数据----
- (void)requestTrajectoryData
{
    hudShowLoading(@"正在请求数据...");
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.busMode.busnum forKey:@"busnum"];
    [dic setObject:@"1" forKey:@"pageNo"];
    [dic setObject:@"3000" forKey:@"pageSize"];
    [self.postMode postDataParameter:dic];
}
#pragma mark  ----ZKBaseClassViewModeDelegate----
/**
 原生数据
 
 @param dictionary 数据
 */
- (void)originalData:(NSDictionary *)dictionary;
{
    
}
/**
 请求结束
 
 @param array 数据源
 */
- (void)postDataEnd:(NSArray *)array;
{
    hudDismiss();
    NSArray *data = [ZKBusTrajectoryMode mj_objectArrayWithKeyValuesArray:array];
    [self.tableView.mj_header endRefreshing];
    [self.trajectoryArray removeAllObjects];
    [self.trajectoryArray addObjectsFromArray:data];
    [self addMapAnnotationView];
    [self addMapPolylines];
    
}
/**
 请求出错了
 
 @param error 错误信息
 */
- (void)postError:(NSString *)error;
{
    hudDismiss();
    [UIView addMJNotifierWithText:error dismissAutomatically:YES];
    [self.tableView.mj_header endRefreshing];
}
/**
 没有更多数据了
 */
- (void)noMoreData;
{
    [self.tableView.mj_header endRefreshing];
}
#pragma mark  ----地图数据处理----

/**
 添加气泡
 */
- (void)addMapAnnotationView
{
    [self.recordArray removeAllObjects];
    if (self.trajectoryArray.count <= 10)
    {
        [self.recordArray addObjectsFromArray:self.trajectoryArray];
    }
    else
    {
        // 取10条数据
        NSInteger num  = self.trajectoryArray.count / 10;
        NSInteger indx = 0;
        for (int i =0; i < 10; i++)
        {
            [self.recordArray addObject:[self.trajectoryArray objectAtIndex:indx]];
            indx = indx +num;
        }
    }
    [self showAnnotationsData:self.recordArray];
}

/**
 显示所要的展示的气泡
 
 @param array 数据
 */
- (void)showAnnotationsData:(NSArray <ZKBusTrajectoryMode *> *)array
{
    [array enumerateObjectsUsingBlock:^(ZKBusTrajectoryMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TBBusAnnotation *pointAnnotation = [[TBBusAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(obj.coordinate_y, obj.coordinate_x);
        pointAnnotation.busMode = obj;
        [self.mapView addAnnotation:pointAnnotation];
    }];
    
    // 拿到第一个数据 选中他
    TBBusAnnotation *annotation = self.mapView.annotations.lastObject;
    
    [self.mapView selectAnnotation:annotation animated:NO];
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}
/**
 添加折线
 */
- (void)addMapPolylines
{
    [self.mapView removeOverlays:self.mapView.overlays];
    // 获取要创建的Polyline数量
    NSInteger number = self.trajectoryArray.count;
    CLLocationCoordinate2D  commonPolylineCoords[number];
    
    for (int i = 0; i<number; i++)
    {
        ZKBusTrajectoryMode *mode = self.trajectoryArray[i];
        commonPolylineCoords[i].latitude = mode.coordinate_y;
        commonPolylineCoords[i].longitude = mode.coordinate_x;
    }
    
    TPolyline *line = [TPolyline polylineWithCoordinates:commonPolylineCoords count:number];
    [self.mapView addOverlay:line];
    [self.mapView setNeedsDisplay];

}
#pragma mark  ----TMapViewDelegate----
/**
 * 生成一个覆盖物的视图
 * @param mapView [in] : 地图视图
 * @param overlay [in] : 需要生成覆盖物视图的覆盖物
 * @return 生成的覆盖物视图
 */
- (TOverlayView *)mapView:(TMapView *)mapView viewForOverlay:(id <TOverlay>)overlay;
{
    if ([overlay isKindOfClass:[TPolyline class]])
    {
        TPolylineView *lineView = [[TPolylineView alloc] initWithPolyline:(TPolyline *)overlay mapView:mapView];
        lineView.lineWidth = 4;
        lineView.fillColor = [UIColor whiteColor];
        lineView.strokeColor = [UIColor redColor];
        return lineView;
    }
    return nil;
}
/**
 * 用户实现创建一个动态标注视图
 * @param mapView    [in] : 图视图
 * @param annotation [in] : 动态标注
 * @return 生成的动态标注视图
 */
- (TAnnotationView *)mapView:(TMapView *)mapView viewForAnnotation:(id <TAnnotation>)annotation
{
    if (self.recordArray.count > 0)
    {
        // 数据源
        TBBusAnnotation *mode = (TBBusAnnotation *)annotation;
        
        static NSString *CellIdentifier = @"busline";
        ZKBusTAnnotationView *annotationView = [[ZKBusTAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:CellIdentifier];
        annotationView.image = [UIImage imageNamed:@"guijiMapQQ"];
        annotationView.selectImage = [UIImage imageNamed:@"guijiMapAdd"];
        annotationView.canShowCallout = TRUE;
        annotationView.busMode = mode.busMode;
        [annotationView createCalloutView];
        CGPoint ptoffset = CGPointMake(annotationView.image.size.width / 2, 0);
        annotationView.calloutOffset = ptoffset;
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
    ZKBusTAnnotationView *annotationView = (ZKBusTAnnotationView *)view;
    [annotationView  updateAddress];
    
    NSArray *arrSelect = mapView.selectedAnnotations;
    [arrSelect enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        id <TAnnotation> ann = obj;
        if (ann != view.annotation) {
            [mapView deselectAnnotation:ann animated:YES];
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.recordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKBusTrajectoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:busCellIdentifier];
    if (self.recordArray.count > indexPath.row)
    {
        // 赋值
        [cell cellAssignmentData:[self.recordArray objectAtIndex:indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.mapView.annotations.count)
    {
        TBBusAnnotation *annotation = self.mapView.annotations[indexPath.row];
        [self.mapView selectAnnotation:annotation animated:NO];
        [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark ---DZNEmptyDataSetSource--

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    text = @"暂无数据可加载 重新加载";
    font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.75];
    textColor = [UIColor grayColor];
    paragraph.lineSpacing = 3.0;
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[attributedString.string rangeOfString:@"重新加载"]];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[attributedString.string rangeOfString:@"重新加载"]];
    return attributedString;
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 10.0f;
}
// 返回可点击按钮的 image
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"noData"];
}
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *imageName = @"noData";
    
    if (state == UIControlStateNormal) imageName = [imageName stringByAppendingString:@"_normal"];
    if (state == UIControlStateHighlighted) imageName = [imageName stringByAppendingString:@"_highlight"];
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsZero;
    
    return [[[UIImage imageNamed:imageName] resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}
#pragma mark ---DZNEmptyDataSetDelegate--

// 处理按钮的点击事件
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view;
{
    [self.tableView.mj_header beginRefreshing];
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button;
{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark  ----创建视图 ----
- (void)createMapView
{
    self.mapView = [[TMapView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, (_SCREEN_HEIGHT-64)/2)];
    self.mapView.CurentMapType = 1;
    self.mapView.delegate = self;
    [self.mapView setMapScale:8.5 animated:YES];
    [self.view addSubview:self.mapView];
}
- (void)createTableView
{
    [self.view addSubview:self.tableView];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestTrajectoryData)];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZKBusTrajectoryTableViewCell class]) bundle:nil] forCellReuseIdentifier:busCellIdentifier];
    YJWeakSelf
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.mapView.mas_bottom);
    }];
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
