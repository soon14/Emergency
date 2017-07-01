//
//  ZKInformationCollectionViewController.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/30.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKInformationCollectionViewController.h"
#import "ZKMainTypeView.h"
#import "ZKReportListView.h"
#import "ZKInformationReportedView.h"

@interface ZKInformationCollectionViewController ()<UIScrollViewDelegate,ZKMainTypeViewDelegate>

@property (nonatomic, strong) ZKMainTypeView *mainTypeView;
//  容器
@property (nonatomic, strong) UIScrollView *contentScrpllView;
//  列表view
@property (nonatomic, strong) ZKReportListView *listView;
//  数据上报view
@property (nonatomic, strong) ZKInformationReportedView *reportedView;
@end

@implementation ZKInformationCollectionViewController
- (UIScrollView *)contentScrpllView
{
    if (!_contentScrpllView)
    {
        _contentScrpllView = [[UIScrollView alloc] init];
        _contentScrpllView.contentOffset = CGPointMake(0, 0);
        _contentScrpllView.contentSize   = CGSizeMake(_SCREEN_WIDTH*2, _SCREEN_HEIGHT -64-MainFilterHeight);
        _contentScrpllView.pagingEnabled = YES;
        _contentScrpllView.showsHorizontalScrollIndicator = NO;
        _contentScrpllView.scrollEnabled = YES;
        _contentScrpllView.delegate      = self;
    }
    return _contentScrpllView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"信息采集";
    [self createViews];
}
#pragma mark  ---- 创建视图----
- (void)createViews
{
    self.mainTypeView = [[ZKMainTypeView  alloc] initFrame:CGRectMake(0, 0, _SCREEN_WIDTH, MainFilterHeight) filters:@[@"已上报",@"我要上报"]];
    self.mainTypeView.delegate = self;
    [self.view addSubview:self.mainTypeView];
    
    [self.view addSubview:self.contentScrpllView];
    self.contentScrpllView.backgroundColor = [UIColor whiteColor];
    
    self.listView = [[ZKReportListView alloc] init];
    self.listView.frame = CGRectMake(0, 0, _SCREEN_WIDTH, self.contentScrpllView.contentSize.height);
    self.listView.userInteractionEnabled = YES;
    [self.contentScrpllView addSubview:self.listView];
    
    self.reportedView = [ZKInformationReportedView obtainReportedView];
    self.reportedView.userInteractionEnabled = YES;
    self.reportedView.frame = CGRectMake(_SCREEN_WIDTH, 0, _SCREEN_WIDTH, self.contentScrpllView.contentSize.height);
    [self.contentScrpllView addSubview:self.reportedView];
    
    YJWeakSelf
    [self.contentScrpllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.mainTypeView.mas_bottom);
    }];
}
#pragma mark  ----UIScrollViewDelegate----
//减速结束   停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int num = scrollView.contentOffset.x / self.view.frame.size.width;
    [self.mainTypeView selectedCurrentItemIndex:num];
}
#pragma mark  ----ZKMainTypeViewDelegate----
/**
 选中代理
 
 @param index 第几个
 */
- (void)selectTypeIndex:(NSInteger)index;
{
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentScrpllView.contentOffset = CGPointMake(_SCREEN_WIDTH * index, 0);
    } completion:^(BOOL finished) {
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
