//
//  ZKHomeViewController.m
//  Emergency
//
//  Created by 王小腊 on 2017/5/3.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKHomeViewController.h"
#import "ZKBaseWebViewController.h"
#import "ZKTourismDataViewController.h"
#import "ZKElectronicMapViewController.h"
#import "ZKHomeBannerView.h"
#import "ZKHomeContentView.h"

@interface ZKHomeViewController ()<ZKHomeContentViewDelegate>
// 横幅
@property (nonatomic, strong) ZKHomeBannerView *bannerView;
// 九宫格视图
@property (nonatomic, strong) ZKHomeContentView *contentView;

@end

@implementation ZKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
}
#pragma mark  ---- 创建视图----
- (void)createViews
{
    self.bannerView = [[ZKHomeBannerView alloc] init];
    self.bannerView.controller = self;
    [self.view addSubview:self.bannerView];
    
    self.contentView = [[ZKHomeContentView alloc] init];
    self.contentView.delegate = self;
    [self.view addSubview:self.contentView];
    YJWeakSelf
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.view);
        make.height.equalTo(@0.1);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.bannerView.mas_bottom);
    }];
    
    self.navigationItem.title = FullName;
    [ZKPostHttp postPath:@"https://appapi.daqsoft.com/groupCQ/tdgl/rest/law?method=login&username=lifeng&password=123456" params:nil success:^(id responseObj) {
        
        
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark  ----ZKHomeContentViewDelegate----

/**
 cell点击
 
 @param dictionary 字典
 */
- (void)homeContentCellClickData:(NSDictionary *)dictionary;
{
    NSString *className = [dictionary valueForKey:@"name"];
    
    if ([className isEqualToString:@"实时人数"]) {
        /**景区实时人数*/
        [self pushViewBundleUrl:@"realnumber" htmlType:nil];
        
    }else if ([className isEqualToString:@"实时监控"]){
        /*  实时监控  */
        
#if LeShan

#else

#endif
    [self.navigationController pushViewController:[NSClassFromString(@"ZKMonitoringViewController") new] animated:YES];
        
    }else if ([className isEqualToString:@"运营商"]||[className isEqualToString:@"汇总大数据"]){
        /*  运营商  */
        [self pushViewBundleUrl:@"Operator" htmlType:nil];
        
    }else if ([className isEqualToString:@"景区"]){
        /*  景点  */
        [self pushViewBundleUrl:@"resourceStatInfo" htmlType:@"type=3"];
        
    }else if ([className isEqualToString:@"酒店"]){
        /* 酒店   */
        [self pushViewBundleUrl:@"resourceStatInfo" htmlType:@"type=1"];
        
    }else if ([className isEqualToString:@"旅行社"]){
        /* 旅行社   */
        [self pushViewBundleUrl:@"resourceStatInfo" htmlType:@"type=2"];
    }else if ([className isEqualToString:@"旅游团队"]){
        
        /* 旅游团队   */
        ZKTourismDataViewController *vc = [[ZKTourismDataViewController alloc] init];
        vc.tourismDataType = TourismDataTypeTeam;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([className isEqualToString:@"旅游大巴"]){
        /* 旅游大巴   */
        ZKTourismDataViewController *vc = [[ZKTourismDataViewController alloc] init];
        vc.tourismDataType = TourismDataTypeBusShowMapBuuton;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([className isEqualToString:@"导游"]){
        /* 导游   */
        [self pushViewBundleUrl:@"resourceStatInfo" htmlType:@"type=4"];
    }else if ([className isEqualToString:@"电子地图"]){
        /*  电子地图  */
        ZKElectronicMapViewController *mavViewController = [[ZKElectronicMapViewController alloc] init];
        [mavViewController mapConfigurationType:ElectronicMapTypeNone dataDefaultData:nil];
        [self.navigationController pushViewController:mavViewController animated:YES];

    }else if ([className isEqualToString:@"信息采集"]){
        /*  信息采集  */

        
    }else if ([className isEqualToString:@"气象数据"]){
        /* 气象数据   */
        

        
    }else if ([className isEqualToString:@"环保数据"]){
        /* 环保数据   */
        
        [self pushViewBundleUrl:@"ProtectInfo" htmlType:nil];
        
    }else if ([className isEqualToString:@"实时数据上报"])
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"reported" bundle:nil];
        [self.navigationController pushViewController:board.instantiateInitialViewController animated:YES];
    }
    else if ([className isEqualToString:@"值班信息"])
    {
        [self.navigationController pushViewController:[NSClassFromString(@"ZKAttendantInformationViewController") new] animated:YES];
        
    }

}
#pragma mark  ----html----

/**
 web网页

 @param url 链接字段
 @param type 类型
 */
- (void)pushViewBundleUrl:(NSString*)url htmlType:(NSString*)type;
{
    NSString *path = [NSString stringWithFormat:@"assets/web/%@", url];
    NSURL *URL = [[NSBundle mainBundle] URLForResource:path withExtension:@"html"];
    if (type.length > 0)
    {
        // 重新拼接url
        NSString *str = [URL absoluteString];
        str = [NSString stringWithFormat:@"%@?%@",str,type];
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        URL = [NSURL URLWithString:str];
    }

    ZKBaseWebViewController *htmlController = [[ZKBaseWebViewController alloc] init];
    htmlController.pathUrl = URL;
    [self.navigationController pushViewController:htmlController animated:YES];
    
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
