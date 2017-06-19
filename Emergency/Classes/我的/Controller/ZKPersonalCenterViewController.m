//
//  ZKPersonalCenterViewController.m
//  Emergency
//
//  Created by 王小腊 on 2017/5/3.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKPersonalCenterViewController.h"
#import "ZKPersonalCenterTableViewCell.h"

static NSString *const ZKPersonalCenterTableViewCellID = @"ZKPersonalCenterTableViewCellID";

@interface ZKPersonalCenterViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ZKPersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.navigationItem.title = @"我的";
    
}
#pragma mark ----初视图---

/**
 创建视图
 */
-(void)initView
{
    //解决在nav 遮挡的时候 还会透明的显示问题;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 20, self.view.frame.size.width-20, 2*55)];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.cornerRadius = 6;
    self.tableView.layer.borderColor = RGB(190, 190, 190).CGColor;
    self.tableView.layer.borderWidth = 1;
    self.tableView.backgroundColor = RGB(230, 230, 230);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZKPersonalCenterTableViewCell" bundle:nil] forCellReuseIdentifier:ZKPersonalCenterTableViewCellID];
    
    UIButton *secedeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secedeButton.frame = CGRectMake(10, self.tableView.frame.size.height+20+40, self.view.frame.size.width-20, 48);
    secedeButton.backgroundColor =CYBColorGreen;
    secedeButton.layer.cornerRadius = 6;
    [secedeButton setTitle:@"退出系统" forState:UIControlStateNormal];
    [secedeButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [secedeButton addTarget:self action:@selector(secedeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secedeButton];
    
    
}
#pragma mark table代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ZKPersonalCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZKPersonalCenterTableViewCellID];
    [cell selectWhichIndex:indexPath.row];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 55.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark  ----按钮点击事件----
- (void)secedeClick
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
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
