//
//  ZKHomeViewController.m
//  Emergency
//
//  Created by 王小腊 on 2017/5/3.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKHomeViewController.h"
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
    //解决在nav 遮挡的时候 还会透明的显示问题;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
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
    
    self.navigationItem.title = APPNAME;
}
#pragma mark  ----ZKHomeContentViewDelegate----

/**
 cell点击
 
 @param dictionary 字典
 */
- (void)homeContentCellClickData:(NSDictionary *)dictionary;
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
