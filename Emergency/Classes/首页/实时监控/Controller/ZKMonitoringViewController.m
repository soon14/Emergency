//
//  ZKMonitoringViewController.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/21.
//  Copyright © 2017年 王小腊. All rights reserved.
//

/**
 按钮点击类型
 
 - SelectedButtonTypeCity: 城市按钮
 - SelectedButtonTypeLevel: 景区等级按钮
 */
typedef NS_ENUM(NSInteger,SelectedButtonType) {
    
    SelectedButtonTypeCity = 0,
    SelectedButtonTypeLevel
};
#import "ZKMonitoringViewController.h"
#import "KxMovieViewController.h"
#import "ZKTimeMonitoringMode.h"
#import "ZKMonitoringCollectionViewCell.h"
#import "ZKTimeMonitoringReusableView.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ZKDataSelectBoxView.h"
#import "ZKBasicDataTool.h"
#import "ZKTextField.h"
@interface ZKMonitoringViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,ZKDataSelectBoxViewDelegate>
// 城市选择数据
@property (nonatomic, strong) NSMutableArray *cityChooseArray;
// 等级选择数据
@property (nonatomic, strong) NSMutableArray *levelChooseArray;
// 城市字段
@property (nonatomic, strong) NSString *cityChoosekey;
// 等级字段
@property (nonatomic, strong) NSString *levelChooseKey;
@property (nonatomic, strong) UIButton *cityChooseButton;
@property (nonatomic, strong) UIButton *levelChooseButton;
// 选择按钮的类型记录
@property (nonatomic) SelectedButtonType selectedType;
// 是否添加城市列表数据
@property (nonatomic, assign) BOOL isAddCityList;
@property (nonatomic, strong) ZKTextField *searchTextField;
@property (nonatomic, strong) NSMutableArray <ZKTimeMonitoringMode *>* modeArray;
@property (nonatomic, strong) NSMutableDictionary *parameter;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layOut;
@end

@implementation ZKMonitoringViewController
- (NSMutableArray *)cityChooseArray
{
    if (!_cityChooseArray)
    {
        _cityChooseArray = [NSMutableArray array];
    }
    return _cityChooseArray;
}
- (NSMutableArray *)levelChooseArray
{
    if (!_levelChooseArray)
    {
        _levelChooseArray = [NSMutableArray array];
    }
    return _levelChooseArray;
}
- (NSMutableArray<ZKTimeMonitoringMode *> *)modeArray
{
    if (!_modeArray)
    {
        _modeArray = [NSMutableArray array];
    }
    return _modeArray;
}
- (NSMutableDictionary *)parameter
{
    if (_parameter == nil)
    {
        _parameter = [NSMutableDictionary dictionary];
    }
    return _parameter;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layOut];
        [_collectionView registerClass:[ZKMonitoringCollectionViewCell class] forCellWithReuseIdentifier:@"ZKMonitoringCollectionViewCellID"];
        //设置为总能垂直滑动就OK了。
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[ZKTimeMonitoringReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        
    }
    return _collectionView;
}
/*设置ColllectionView约束*/

- (UICollectionViewFlowLayout *)layOut
{
    if (!_layOut) {
        _layOut = [[UICollectionViewFlowLayout alloc] init];
        _layOut.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layOut.headerReferenceSize = CGSizeMake(_SCREEN_WIDTH, 40);
        _layOut.minimumLineSpacing = 0.0f;
        _layOut.minimumInteritemSpacing = 0.0f;
    }
    return _layOut;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestChooseData];
    [self createViews];
    
}
#pragma mark  ----数据请求----
- (void)reloadData
{
    hudShowLoading(@"加载中...");
    [self.parameter setObject:self.cityChoosekey forKey:@"region"];
    [self.parameter setObject:self.levelChooseKey forKey:@"levels"];
    [self.parameter setObject:self.searchTextField.text forKey:@"name"];
    [self.parameter setObject:@"" forKey:@"resourcecode"];
    YJWeakSelf
    [ZKPostHttp post:@"appVideo/videoList" params:self.parameter success:^(id responseObj) {
        
        NSString *state = [responseObj valueForKey:@"state"];
        NSString *message = [responseObj valueForKey:@"message"];
        [weakSelf.collectionView.mj_header endRefreshing];
        hudDismiss();
        [UIView addMJNotifierWithText:message dismissAutomatically:YES];
        if ([state isEqualToString:@"success"])
        {
            [weakSelf responseData:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        [weakSelf.collectionView.mj_header endRefreshing];
        hudShowError(@"网络异常！");
    }];
}
// 数据处理
- (void)responseData:(NSDictionary *)obj
{
    [self.modeArray removeAllObjects];
    
    // 第一次添加城市数据
    if (self.isAddCityList == NO)
    {
        NSString *totalString = [NSString stringWithFormat:@"不限（%@个）",[obj valueForKey:@"total"]];
        [self.cityChooseButton setTitle:totalString forState:UIControlStateNormal];
        [self.cityChooseArray insertObject:@{@"name":totalString,@"region":@""} atIndex:0];
        self.isAddCityList = YES;
    }
    
    NSArray *data   = [obj valueForKey:@"data"];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZKTimeMonitoringMode *mode = [[ZKTimeMonitoringMode alloc] initDictionary:obj];
        [self.modeArray addObject:mode];
    }];
    
    self.collectionView.backgroundColor =self.modeArray.count == 0 ? [UIColor groupTableViewBackgroundColor]:[UIColor whiteColor];
    [self.collectionView reloadData];
}
#pragma mark  ----创建视图----
- (void)createViews
{
    self.navigationItem.title = @"实时监控";
    self.cityChoosekey = @"";
    self.levelChooseKey = @"";
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    self.cityChooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cityChooseButton setTitle:@"不限" forState:UIControlStateNormal];
    self.cityChooseButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.cityChooseButton addTarget:self action:@selector(cityChooseClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.cityChooseButton];
    
    UIImageView *cityChooseView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shanjiao_1"]];
    [self.cityChooseButton addSubview:cityChooseView];
    
    self.levelChooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.levelChooseButton setTitle:@"不限" forState:UIControlStateNormal];
    self.levelChooseButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.levelChooseButton addTarget:self action:@selector(levelChooseClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.levelChooseButton];
    
    UIImageView *levelChooseView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shanjiao_1"]];
    [self.levelChooseButton addSubview:levelChooseView];
    //初始化选择按钮设置
    [self selectChooseButtonIsCityButton:YES];
    
    self.searchTextField = [[ZKTextField alloc]init];
    self.searchTextField.backgroundColor = [UIColor whiteColor];
    self.searchTextField.layer.masksToBounds = YES;
    self.searchTextField.layer.borderColor = BODER_COLOR.CGColor;
    self.searchTextField.layer.borderWidth = 0.5;
    self.searchTextField.textColor = [UIColor blackColor];
    self.searchTextField.placeholder = @"输入关键字搜索";
    self.searchTextField.textAlignment = NSTextAlignmentLeft;
    self.searchTextField.font = [UIFont systemFontOfSize:16];
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.delegate = self;
    [self.view addSubview:self.searchTextField];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.searchTextField addSubview:searchButton];
    
    [self.view addSubview:self.collectionView];
    
    self.collectionView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    
    YJWeakSelf
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf.view);
        make.height.equalTo(@60);
    }];
    [self.cityChooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(16);
        make.top.equalTo(headerView.mas_top).offset(10);
        make.bottom.equalTo(headerView.mas_bottom).offset(-10);
    }];
    [self.levelChooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(headerView.mas_right).offset(-16);
        make.top.equalTo(headerView.mas_top).offset(10);
        make.bottom.equalTo(headerView.mas_bottom).offset(-10);
        make.left.equalTo(weakSelf.cityChooseButton.mas_right);
        make.width.equalTo(weakSelf.cityChooseButton.mas_width);
    }];
    
    [cityChooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.cityChooseButton.mas_right).offset(-14);
        make.bottom.equalTo(weakSelf.cityChooseButton.mas_bottom).offset(-14);
        make.height.width.equalTo(@10);
    }];
    [levelChooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.levelChooseButton.mas_right).offset(-14);
        make.bottom.equalTo(weakSelf.levelChooseButton.mas_bottom).offset(-14);
        make.height.width.equalTo(@10);
    }];
    
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(16);
        make.right.equalTo(weakSelf.view.mas_right).offset(-16);
        make.top.equalTo(headerView.mas_bottom).offset(8);
        make.height.equalTo(@38);
    }];
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.searchTextField.mas_centerY);
        make.right.equalTo(weakSelf.searchTextField.mas_right).offset(1);
        make.width.height.equalTo(@44);
        
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.searchTextField.mas_bottom).offset(10);
    }];
}
#pragma mark  ----选择条件数据加载----
- (void)requestChooseData
{
    //    获取单利对象
    ZKBasicDataTool *tool = [ZKBasicDataTool sharedManager];
    //    加载城市数据
    YJWeakSelf
    [tool obtainCityTwo:^(NSArray *cityTwo)
     {
         [weakSelf.cityChooseArray addObjectsFromArray:cityTwo];
         
     }];
    //    加载等级数据
    [tool obtainLevelstrArray:^(NSArray *levelstrArray)
     {
         [weakSelf.levelChooseArray addObject:@{@"slevel":@"不限",@"type":@""}];
         [weakSelf.levelChooseArray addObjectsFromArray:levelstrArray];
     }];
}
#pragma mark  ----按钮点击----
- (void)cityChooseClick:(UIButton *)sender
{
    if (self.cityChooseArray.count == 0)
    {
        [UIView addMJNotifierWithText:@"城市数据还在加载中" dismissAutomatically:YES];
        return;
    }
    [self selectChooseButtonIsCityButton:YES];
    [self showBoxViewDataType:YES];
}
- (void)levelChooseClick:(UIButton *)sender
{
    if (self.levelChooseArray.count == 0)
    {
        [UIView addMJNotifierWithText:@"景区等级数据还在加载中" dismissAutomatically:YES];
        return;
    }
    [self selectChooseButtonIsCityButton:NO];
    [self showBoxViewDataType:NO];
}
// 搜索按钮点击
- (void)searchRequest
{
    [self reloadData];
    [self.searchTextField resignFirstResponder];
}
#pragma mark  ----UICollectionViewDelegate----
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.modeArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    ZKTimeMonitoringMode *mode = self.modeArray[section];
    return mode.mname.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZKMonitoringCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZKMonitoringCollectionViewCellID" forIndexPath:indexPath];
    
    if (self.modeArray.count>0)
    {
        ZKTimeMonitoringMode *mode = self.modeArray[indexPath.section];
        ZKTimeMonitoringVideoMode *list = mode.mname[indexPath.row];
        [cell updata:list];
    }
    
    [cell setVideoButtonClick:^(NSString *url) {
        
        [self playerVideoUrl:url];
        
    }];
    return cell;
}
- (void)playerVideoUrl:(NSString *)url
{
    NSString *path = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    // increase buffering for .wmv, it solves problem with delaying audio frames
    if ([path.pathExtension isEqualToString:@"wmv"])
        parameters[KxMovieParameterMinBufferedDuration] = @(5.0);
    
    // disable deinterlacing for iPhone, because it's complex operation can cause stuttering
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        parameters[KxMovieParameterDisableDeinterlacing] = @(NO);
    
    KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:path
                                                                               parameters:parameters];
    [self presentViewController:vc animated:YES completion:nil];
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_SCREEN_WIDTH / 2, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(_SCREEN_WIDTH, 40);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
{
    if (section == self.modeArray.count-1)
    {
        return CGSizeMake(_SCREEN_WIDTH, 40);
    }
    return CGSizeMake(_SCREEN_WIDTH, 8);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        ZKTimeMonitoringMode *mode = self.modeArray[indexPath.section];
        ZKTimeMonitoringReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        [headerView updataTitle:mode.name];
        
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter){
        
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [footerview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if (self.modeArray.count - 1 == indexPath.section && self.modeArray.count >0)
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
    [self.searchTextField resignFirstResponder];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchTextField resignFirstResponder];
}
#pragma mark  ----ZKDataSelectBoxViewDelegate----
/**
 弹出框选中的数据
 
 @param data 数据
 */
- (void)boxViewSelectedData:(NSDictionary *)data;
{
    if (self.selectedType == SelectedButtonTypeCity)
    {
        self.cityChoosekey = [data valueForKey:@"region"];
        [self.cityChooseButton setTitle:[data valueForKey:@"name"] forState:UIControlStateNormal];
    }
    else if (self.selectedType == SelectedButtonTypeLevel)
    {
        self.levelChooseKey = [data valueForKey:@"type"];
        [self.levelChooseButton setTitle:[data valueForKey:@"slevel"] forState:UIControlStateNormal];
    }
    [self reloadData];
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
    [self.collectionView.mj_header beginRefreshing];
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button;
{
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark  ----UITextFieldDelegate----
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [self.searchTextField resignFirstResponder];
    [self reloadData];
    return YES;
}
#pragma mark  ----其它逻辑----

/**
 弹出选择框
 
 @param type 弹出类型
 */
- (void)showBoxViewDataType:(BOOL)type
{
    ZKDataSelectBoxView *boxview = [[ZKDataSelectBoxView alloc] initShowPrompt:type == YES?@"按区域选择":@"按景区等级选择" data:type == YES?self.cityChooseArray:self.levelChooseArray cellNameKey:type == YES?@"name":@"slevel" selectName:type == YES?self.cityChooseButton.titleLabel.text:self.levelChooseButton.titleLabel.text ];
    boxview.delegate = self;
    [boxview show];
    
    self.selectedType = type == YES?SelectedButtonTypeCity:SelectedButtonTypeLevel;
    
}
/**
 选择按钮点击
 
 @param type 是否选择城市按钮呢
 */
- (void)selectChooseButtonIsCityButton:(BOOL)type
{
    [self.searchTextField resignFirstResponder];
    
    UIControlState buttonNormalState = type?UIControlStateNormal:UIControlStateHighlighted;
    UIControlState buttonHighlightedState = type?UIControlStateHighlighted:UIControlStateNormal;
    
    // 根据状态显示图片和字体颜色
    [self.cityChooseButton setBackgroundImage:[UIImage imageNamed:@"Selectbutton_0"] forState:buttonNormalState];
    [self.cityChooseButton setBackgroundImage:[UIImage imageNamed:@"Selectbutton_1"] forState:buttonHighlightedState];
    [self.cityChooseButton.titleLabel sizeToFit];
    [self.cityChooseButton setTitleColor:[UIColor whiteColor] forState:buttonNormalState];
    [self.cityChooseButton setTitleColor:CYBColorGreen forState:buttonHighlightedState];
    
    [self.levelChooseButton setBackgroundImage:[UIImage imageNamed:@"Selectbutton_2"] forState:buttonHighlightedState];
    [self.levelChooseButton setBackgroundImage:[UIImage imageNamed:@"Selectbutton_3"] forState:buttonNormalState];
    [self.levelChooseButton.titleLabel sizeToFit];
    [self.levelChooseButton setTitleColor:[UIColor whiteColor] forState:buttonHighlightedState];
    [self.levelChooseButton setTitleColor:CYBColorGreen forState:buttonNormalState];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.searchTextField resignFirstResponder];
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
