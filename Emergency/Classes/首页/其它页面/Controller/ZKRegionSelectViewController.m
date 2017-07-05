//
//  ZKRegionSelectViewController.m
//  Emergency
//
//  Created by 王小腊 on 2017/7/5.
//  Copyright © 2017年 王小腊. All rights reserved.
//
// 间隙
static CGFloat cellClearance = 6;

/**
 CollectionView状态
 
 - CollectionViewStateChoose: 常规状态
 - CollectionViewStateSearch: 搜索状态
 */
typedef NS_ENUM(NSInteger, CollectionViewState)
{
    CollectionViewStateChoose = 0,
    CollectionViewStateSearch
};
#import "ZKRegionSelectViewController.h"
#import "ZKRegionSelectCollectionViewCell.h"
#import "ZKTimeMonitoringReusableView.h"
#import "TBTaskSearchView.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ZKBasicDataTool.h"
#import "ZKBaseClassViewMode.h"
#import "ZKRegionSelectMode.h"
@interface ZKRegionSelectViewController ()<ZKBaseClassViewModeDelegate,UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet TBTaskSearchView *searchView;
/**
 当前定位地区
 */
@property (weak, nonatomic) IBOutlet UILabel *locationNameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layOut;
// 选择数据
@property (nonatomic, strong) ZKRegionSelectMode *selectMode;
@property (nonatomic, strong) NSMutableDictionary *parameter;
@property (nonatomic, strong) ZKBaseClassViewMode *viewMode;
@property (nonatomic, strong) NSString *searchKeyword;
// 显示状态
@property (nonatomic) CollectionViewState viewState;
@property (nonatomic, assign) CGSize citySize;
@property (nonatomic, assign) CGSize scenicSpotSize;
@property (nonatomic, assign) CGSize listSize;

@end

@implementation ZKRegionSelectViewController
#pragma mark  ----懒加载区域----
- (ZKBaseClassViewMode *)viewMode
{
    if (!_viewMode)
    {
        _viewMode = [[ZKBaseClassViewMode alloc] init];
        _viewMode.delegate = self;
        _viewMode.url = @"appScency/scencyList";
    }
    return _viewMode;
}
- (NSMutableDictionary *)parameter
{
    if (!_parameter)
    {
        _parameter = [NSMutableDictionary dictionary];
        _parameter[@"pageSize"] = @"20";
        _parameter[@"pageNo"] = @"1";
    }
    return _parameter;
}
/*设置ColllectionView约束*/

- (UICollectionViewFlowLayout *)layOut
{
    if (!_layOut) {
        _layOut = [[UICollectionViewFlowLayout alloc] init];
        _layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layOut.minimumLineSpacing = cellClearance;
        _layOut.minimumInteritemSpacing = cellClearance;
    }
    return _layOut;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"地点选择";
    [self setUpCollectionView];
    [self initializeData];
}
#pragma mark  ----设置collectionView----
- (void)setUpCollectionView
{
    CGFloat cellHeight = 30.0f;
    // 多减一像素 防止超出
    self.citySize = CGSizeMake((_SCREEN_WIDTH - cellClearance*5)/4 - 2, cellHeight);
    self.scenicSpotSize = CGSizeMake((_SCREEN_WIDTH - cellClearance*3)/2 - 4, cellHeight);
    self.listSize = CGSizeMake(_SCREEN_WIDTH, cellHeight);
    
    self.collectionView.collectionViewLayout = self.layOut;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.bounces = YES;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    
    [self.collectionView registerClass:[ZKRegionSelectCollectionViewCell class] forCellWithReuseIdentifier:ZKRegionSelectCollectionViewCellID];
    [self.collectionView registerClass:[ZKTimeMonitoringReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    
}
#pragma mark  ----初始化数据----
- (void)initializeData
{
    self.locationNameLabel.text = self.locationName;
    self.selectMode = [[ZKRegionSelectMode alloc] init];;
    YJWeakSelf
    //    城市数据
    [[ZKBasicDataTool sharedManager] obtainCityOne:^(NSArray *cityOne)
     {
         weakSelf.selectMode.cityArray = [ZKRegionSelectCityMode mj_objectArrayWithKeyValuesArray:cityOne];
         [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
     }];
    //    热门景点
    [[ZKBasicDataTool sharedManager] obtainHotScenicSpotData:^(NSArray *scenicSpotData)
     {
         weakSelf.selectMode.scenicSpotArray = [ZKRegionSelectScenicSpotMode mj_objectArrayWithKeyValuesArray:scenicSpotData];
         [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
     }];
    
    [self.searchView setSearchResult:^(NSString *key) {
        weakSelf.searchKeyword = key;
        [weakSelf searchData];
    }];
    [self.searchView setSearchTextDidChange:^(NSString *key) {
        
        if (key.length == 0)
        {
            weakSelf.selectMode.searchData = nil;
            weakSelf.viewState = CollectionViewStateChoose;
            [weakSelf.collectionView reloadData];
        }
    }];
}

/**
 清空数据
 */
- (void)emptyData
{
    if (self.selectMode.historicalData.count == 0)
    {
        return;
    }
    hudShowLoading(@"正在清空数据");
    YJWeakSelf
    [self.selectMode emptyHistoryDataSuccessful:^(BOOL saveState)
     {
         hudDismiss();
         [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
         [UIView addMJNotifierWithText:saveState?@"已清空":@"清空数据失败" dismissAutomatically:YES];
     }];
}
#pragma mark  ----UICollectionViewDelegate----
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.viewState == CollectionViewStateChoose)
    {
        return 3;
    }
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.viewState == CollectionViewStateChoose)
    {
        if (section == 0)
        {
            return self.selectMode.cityArray.count;
        }
        else if (section == 1)
        {
            return self.selectMode.scenicSpotArray.count;
        }
        else
        {
            return self.selectMode.historicalData.count;
        }
    }
    return self.selectMode.searchData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZKRegionSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZKRegionSelectCollectionViewCellID forIndexPath:indexPath];
    NSString *name = @"";
    if (self.viewState == CollectionViewStateChoose) {
        
        if (indexPath.section == 0)
        {
            ZKRegionSelectCityMode *list = [self.selectMode.cityArray objectAtIndex:indexPath.row];
            name = list.cityname;
            cell.nameLabel.textColor = [name isEqualToString:self.locationName]?[UIColor orangeColor]:[UIColor blackColor];
        }
        else if (indexPath.section == 1)
        {
            ZKRegionSelectScenicSpotMode *list = [self.selectMode.scenicSpotArray objectAtIndex:indexPath.row];
            name = list.sname;
            cell.nameLabel.textColor = [name isEqualToString:self.locationName]?[UIColor orangeColor]:[UIColor blackColor];
        }
        else if (indexPath.section == 2)
        {
            name = [self.selectMode.historicalData objectAtIndex:indexPath.row];
             cell.nameLabel.textColor = [UIColor blackColor];
        }
    }
    else if (self.viewState == CollectionViewStateSearch)
    {
        ZKScenicResourceStatMode *list = [self.selectMode.searchData objectAtIndex:indexPath.row];
        name = list.name;
        cell.nameLabel.textColor = [UIColor blackColor];
    }
    cell.nameLabel.text = name;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.viewState == CollectionViewStateChoose)
    {
        if (indexPath.section == 0)
        {
            return self.citySize;
        }
        else if (indexPath.section == 1)
        {
            return self.scenicSpotSize;
        }
        else
        {
            return self.listSize;
        }
    }
    return self.listSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.viewState == CollectionViewStateSearch) {
        return CGSizeMake(0.0f, 0.0f);
    }
    return CGSizeMake(_SCREEN_WIDTH, 40);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
{
    if (self.viewState == CollectionViewStateSearch)
    {
        return CGSizeMake(_SCREEN_WIDTH, 40);
    }
    else
    {
        if (section == 2)
        {
            return CGSizeMake(_SCREEN_WIDTH, 40);
        }
        else
        {
            return CGSizeMake(0.0f, 0.0f);
        }
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader && self.viewState == CollectionViewStateChoose){
        
        ZKTimeMonitoringReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        NSString *name = indexPath.section == 0 ? @"城市选择" : (indexPath.section == 1 ? @"热门景点选择" : @"搜索历史");
        [headerView updataTitle:name];
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter && (indexPath.section == 2 || self.viewState == CollectionViewStateSearch)){
        
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [footerview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        if (self.viewState == CollectionViewStateChoose)
        {
            UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
            centerButton.backgroundColor = [UIColor whiteColor];
            [centerButton setTitle:self.selectMode.historicalData.count == 0 ?@"没有历史搜索记录":@"清空历史搜索记录" forState:UIControlStateNormal];
            centerButton.layer.masksToBounds = YES;
            [centerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            centerButton.titleLabel.font = [UIFont systemFontOfSize:13];
            [centerButton addTarget:self action:@selector(emptyData) forControlEvents:UIControlEventTouchUpInside];
            centerButton.layer.borderColor = BODER_COLOR.CGColor;
            centerButton.layer.borderWidth = 0.5;
            [footerview addSubview:centerButton];
            
            [centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(footerview);
            }];
        }
        else if (self.viewState == CollectionViewStateSearch)
        {
            UILabel *centerLabel = [[UILabel alloc] init];
            centerLabel.textColor = [UIColor grayColor];
            centerLabel.text = @"数据显示完毕";
            centerLabel.font = [UIFont systemFontOfSize:14];
            [footerview addSubview:centerLabel];
            
            [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.center.equalTo(footerview);
            }];
            
        }
        
        reusableview = footerview;
    }
    return reusableview;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    if (indexPath.section == 2 && self.viewState == CollectionViewStateChoose)
    {
        self.searchKeyword = [self.selectMode.historicalData objectAtIndex:indexPath.row];
        [self.searchView assignmentText:self.searchKeyword];
        [self searchData];
        return;
    }
    
    BOOL isCity = YES;
    NSString *code = @"";
    
    if (self.viewState == CollectionViewStateChoose) {
        
        if (indexPath.section == 0)
        {
            ZKRegionSelectCityMode *list = [self.selectMode.cityArray objectAtIndex:indexPath.row];
            isCity = YES;
            code = list.region;
            
        }
        else if (indexPath.section == 1)
        {
            ZKRegionSelectScenicSpotMode *list = [self.selectMode.scenicSpotArray objectAtIndex:indexPath.row];
            isCity = NO;
            code = list.resourcecode;
        }
    }
    else if (self.viewState == CollectionViewStateSearch)
    {
        ZKScenicResourceStatMode *list = [self.selectMode.searchData objectAtIndex:indexPath.row];
        isCity = NO;
        code = list.resourcecode;
    }
    
    if (self.selectData)
    {
        self.selectData(code,isCity);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
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
    
    UIEdgeInsets capInsets  = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsZero;
    
    return [[[UIImage imageNamed:imageName] resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}
#pragma mark ---DZNEmptyDataSetDelegate--

// 处理按钮的点击事件
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view;
{
    if (self.viewState == CollectionViewStateChoose)
    {
        [UIView addMJNotifierWithText:@"数据正在加载" dismissAutomatically:YES];
        [self initializeData];
    }
    else
    {
        [self searchData];
    }
    
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button;
{
    if (self.viewState == CollectionViewStateChoose)
    {
        [UIView addMJNotifierWithText:@"数据正在加载" dismissAutomatically:YES];
        [self initializeData];
        
    }
    else
    {
        [self searchData];
    }
}
#pragma mark  ----数据搜索----
- (void)searchData
{
    if (self.searchKeyword.length == 0)
    {
        [UIView addMJNotifierWithText:@"请输入关键字查询！" dismissAutomatically:YES];
        return;
    }
    hudShowLoading(@"正在查询...");
    [self.parameter setValue:self.searchKeyword forKey:@"name"];
    [self.viewMode postDataParameter:self.parameter];
}
#pragma mark  ----ZKBaseClassViewModeDelegate----
/**
 请求结束
 
 @param dataArray 数据源
 */
- (void)postDataEnd:(NSArray *)dataArray;
{
    hudDismiss();
    self.viewState = dataArray.count != 0;
    [UIView addMJNotifierWithText:dataArray.count == 0?@"未查询到数据":@"查询成功" dismissAutomatically:YES];
    self.selectMode.searchData = [ZKScenicResourceStatMode mj_objectArrayWithKeyValuesArray:dataArray];
    [self.collectionView reloadData];
    // 保存搜索字段
    [self.selectMode saveSearchHistoryData:self.searchKeyword successful:^(BOOL saveState) {
        
    } ];
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
/**
 没有更多数据了
 */
- (void)noMoreData;
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
