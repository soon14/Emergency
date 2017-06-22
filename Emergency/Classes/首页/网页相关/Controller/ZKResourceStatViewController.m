//
//  ZKResourceStatViewController.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/22.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKResourceStatViewController.h"
#import "ZKResourceChooseView.h"

@interface ZKResourceStatViewController ()

@property (nonatomic, strong) ZKResourceChooseView *chooseView;

@end

@implementation ZKResourceStatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark  ----创建头部选择视图----
- (void)createHeaderView
{
    self.chooseView = [ZKResourceChooseView resourceChooseView];
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
#pragma mark  ----super 方法----
- (void)initData;
{
    [super initData];
}
- (void)setUpView;
{
    [super setUpView];
    [self createHeaderView];
}
- (void)endDataRequest;//数据请求结束
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
