//
//  ZKElectronicLtineraryViewController.m
//  yjPingTai
//
//  Created by 王小腊 on 2016/11/1.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKElectronicLtineraryViewController.h"
#import "ZKTourismDataTeamMode.h"
#import "ZKElectronicLtineraryMode.h"
#import "ZKElectronicLtineraryCell.h"
#import "UIScrollView+EmptyDataSet.h"

@interface ZKElectronicLtineraryViewController ()<UITableViewDataSource,UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSInteger dex_map;
    NSMutableArray *dataArray;
}

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dtdylabel;
@property (weak, nonatomic) IBOutlet UILabel *ctrsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lysjlabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ZKElectronicLtineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"电子行程单";
    
    dataArray =[NSMutableArray arrayWithCapacity:0];
    [self initView];
}

#pragma mark  初始化视图

-(void)initView
{
    [self updataHeaderView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self postData];
    
}
#pragma mark 请求
-(void)postData
{
    hudShowLoading(@"数据加载中...");
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [dic setObject:self.list.ID forKey:@"tid"];
    
    [ZKPostHttp post:@"appTours/toursDetailList" params:dic success:^(id responseObj) {
        hudDismiss();
        NSArray *array =[responseObj valueForKey:@"data"];
        
        if (array.count>0)
        {
            dataArray = [ZKElectronicLtineraryMode mj_objectArrayWithKeyValuesArray:array];
            /**
             *  更新数据
             */
            [self updataView];
            
        }else{
            
            [UIView addMJNotifierWithText:@"该团队暂没有行程信息!" dismissAutomatically:YES];
        }
        
    } failure:^(NSError *error) {
        hudShowError(@"网络异常！");
    }];
    
}

#pragma mark 数据更新
-(void)updataView
{
    [self.tableView reloadData];
}

-(void)updataHeaderView;
{
    self.nameLabel.text = self.list.tname;
    
    self.dtdylabel.text =[NSString stringWithFormat:@"%@",self.list.name];
    self.ctrsLabel.text =[NSString stringWithFormat:@"%@人",self.list.amount];
    NSString *kai =[self.list.arrivetime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *wei =[self.list.leavetime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    
    self.lysjlabel.text =[NSString stringWithFormat:@"%@ - %@",kai,wei];
    
}
#pragma mark table代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ZKElectronicLtineraryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        cell =[[ZKElectronicLtineraryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    if (dataArray.count>0)
    {
        if (indexPath.row == dex_map)
        {
            [cell update:dataArray[indexPath.row] Largen:YES index:indexPath.row];
        }else{
            
            [cell update:dataArray[indexPath.row] Largen:NO index:indexPath.row];
        }
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataArray.count == 0) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    dex_map =indexPath.row;
    [self.tableView reloadData];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    return [[UIView alloc]init];
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
    [self postData];
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button;
{
    [self postData];
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
