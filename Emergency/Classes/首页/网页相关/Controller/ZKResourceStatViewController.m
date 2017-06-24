//
//  ZKResourceStatViewController.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/22.
//  Copyright © 2017年 王小腊. All rights reserved.
//

NSString *const resourceCellIIdentifier = @"resourceCellIIdentifier";

#import "ZKResourceStatViewController.h"
#import "ZKResourceChooseView.h"

#import "ZKHotelResourceStatMode.h"
#import "ZKTravelResourceStatMode.h"
#import "ZKScenicResourceStatMode.h"
#import "ZKGuideResourceStatMode.h"

#import "ZKHotelResourceStatCell.h"
#import "ZKTravelResourceStatCell.h"
#import "ZKScenicResourceStatCell.h"
#import "ZKGuideResourceStatCell.h"

#import "UIBarButtonItem+Custom.h"
@interface ZKResourceStatViewController ()<ZKResourceChooseViewDelegate>

@property (nonatomic, strong) ZKResourceChooseView *chooseView;

@property (nonatomic) ResourceStatType resourceStatType;
// 等级显示字段
@property (nonatomic, strong) NSString *levelName;
// 参数level值
@property (nonatomic, strong) NSString *level;
// 地区值显示字段
@property (nonatomic, strong) NSString *regionName;
// 地区值
@property (nonatomic, strong) NSString *region;

@end

@implementation ZKResourceStatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
#pragma mark  ----UITableView----

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKResourceStatBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:resourceCellIIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.roots.count > indexPath.row)
    {
      [cell assignmentCellData:[self.roots objectAtIndex:indexPath.row]];
    }
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark  ----数据配置----
/**
 配置数据
 
 @param type 资源类型
 @param defaultData 按钮默认值 @{@"left":@"-",@"region":@"-", @"right":@"-",@"level":@"-"}
 @param isMap 是否地图跳转过来的
 */
- (void)configurationDataSearchType:(ResourceStatType)type buttonDefaultData:(NSDictionary *)defaultData isMap:(BOOL)isMap;
{
    if (defaultData.count == 4)
    {
        self.levelName = [defaultData valueForKey:@"right"];
        self.level = [defaultData valueForKey:@"level"];
        self.regionName = [defaultData valueForKey:@"left"];
        self.region = [defaultData valueForKey:@"region"];
    }
    self.resourceStatType = type;
    if (isMap == NO)
    {
        [self addRightBarButtonItem];
    }

}

/**
 修改请求参数
 */
- (void)modifyPostParameter
{
    [self.parameter setObject:self.level forKey:@"levels"];
    [self.parameter setObject:self.region forKey:@"region"];
}
#pragma mark  ----创建头部选择视图----
- (void)createHeaderView
{
    self.chooseView = [ZKResourceChooseView resourceChooseView];
    [self.chooseView configurationDataSearchType:(NSInteger)self.resourceStatType leftTitle:self.regionName rightTitle:self.levelName];
    self.chooseView.delegate = self;
    [self.view addSubview:self.chooseView];
    
    YJWeakSelf
    [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.right.top.equalTo(weakSelf.view);
         make.height.equalTo(@104);
     }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(weakSelf.chooseView.mas_bottom);
         make.left.right.bottom.equalTo(weakSelf.view);
     }];
}

/**
 添加地图跳转按钮
 */
- (void)addRightBarButtonItem
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem setRitWithTitel:@"" itemWithIcon:@"itemMap" target:self action:@selector(goMap)];
}
#pragma mark  ----super 方法----
- (void)initData;
{
    if (self.resourceStatType == ResourceStatTypeHotel)
    {
        self.postUrl = @"appHotel/hotelList";
        self.modeClass = [ZKHotelResourceStatMode class];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZKHotelResourceStatCell class]) bundle:nil] forCellReuseIdentifier:resourceCellIIdentifier];
        self.navigationItem.title = @"酒店";
    }
    else if (self.resourceStatType == ResourceStatTypeTravel)
    {
        self.postUrl = @"appTravel/travelList";
        self.modeClass = [ZKTravelResourceStatMode class];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZKTravelResourceStatCell class]) bundle:nil] forCellReuseIdentifier:resourceCellIIdentifier];
        self.navigationItem.title = @"旅行社";
    }
    else if (self.resourceStatType == ResourceStatTypeScenic)
    {
        self.postUrl = @"appScency/scencyList";
        self.modeClass = [ZKScenicResourceStatMode class];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZKScenicResourceStatCell class]) bundle:nil] forCellReuseIdentifier:resourceCellIIdentifier];
        self.navigationItem.title = @"景区";
    }
    else if (self.resourceStatType == ResourceStatTypeGuide)
    {
        self.postUrl = @"appGuide/guideList";
        self.modeClass = [ZKGuideResourceStatMode class];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZKGuideResourceStatCell class]) bundle:nil] forCellReuseIdentifier:resourceCellIIdentifier];
        self.navigationItem.title = @"导游";
    }
    [super initData];
    [self modifyPostParameter];
}
- (void)setUpView;
{
    [super setUpView];
    [self createHeaderView];
}
- (void)endDataRequest;//数据请求结束
{
    
}
#pragma mark  ----按钮点击事件----
- (void)goMap
{
    
}
#pragma mark  ----ZKResourceChooseViewDelegate----
/**
 搜索回调
 
 @param key 搜索字段
 */
- (void)searchResultString:(NSString *)key;
{
    [self.parameter setObject:key forKey:@"name"];
    [self.tableView.mj_header beginRefreshing];
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
    [self modifyPostParameter];
    [self.tableView.mj_header beginRefreshing];
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
