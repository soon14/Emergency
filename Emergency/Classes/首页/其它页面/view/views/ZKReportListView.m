//
//  ZKReportListView.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/30.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKReportListView.h"
#import "ZKDealViewController.h"
#import "DetailViewController.h"
#import "ZKInformationDealTableViewCell.h"
#import "ZKInformationCollectionTableViewCell.h"
#import "ZKBaseClassViewMode.h"
#import "ZKInformationCollectionMode.h"
#import "UIScrollView+EmptyDataSet.h"
#import <AVFoundation/AVFoundation.h>

@interface ZKReportListView ()<ZKBaseClassViewModeDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UITableViewDelegate,UITableViewDataSource,ZKInformationCollectionTableViewCellDelegate,AVAudioPlayerDelegate,NSURLConnectionDelegate>

@property (nonatomic, strong) ZKBaseClassViewMode *viewMode;
@property (nonatomic, strong) NSMutableDictionary *parameter;
@property (nonatomic, strong) NSMutableArray <ZKInformationCollectionMode *>*dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
// 声音播放图片
@property (nonatomic, strong) UIImageView *voiceImageView;
@property (nonatomic, strong) NSMutableData *voiceData;
@property (nonatomic, strong) AVAudioPlayer *play;
@end
@implementation ZKReportListView
#pragma mark  ----懒加载区域----
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}
- (ZKBaseClassViewMode *)viewMode
{
    if (!_viewMode)
    {
        _viewMode = [[ZKBaseClassViewMode alloc] init];
        _viewMode.delegate = self;
        _viewMode.url = @"appEmergency/emergencyList";
    }
    return _viewMode;
}
- (NSMutableDictionary *)parameter
{
    if (!_parameter)
    {
        _parameter = [NSMutableDictionary dictionary];
    }
    return _parameter;
}
- (NSMutableArray<ZKInformationCollectionMode *> *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (instancetype)init
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor redColor];
        [self initData];
        [self setUpView];
        [self setTheAudio];
        
    }
    return self;
}
#pragma mark ---参数配置---
- (void)initData
{
    self.parameter[@"pageSize"] = @"20";
}
// 设置音频
- (void)setTheAudio
{
    // 解决真机播放声音太小问题
    NSError *categoryError = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&categoryError];
    [audioSession setActive:YES error:&categoryError];
    
    NSError *audioError = nil;
    BOOL success = [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&audioError];
    if (!success)
    {
        [UIView addMJNotifierWithText:@"手机声音播放器异常！" dismissAutomatically:YES];
    }
}
#pragma mark ---初始化视图----
- (void)setUpView
{
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.page = 1;
    [self addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 10)];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    self.tableView.mj_footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoadingData)];
    
#if guangD
    [self.tableView registerNib:[UINib nibWithNibName:@"ZKInformationDealTableViewCell" bundle:nil] forCellReuseIdentifier:ZKInformationDealTableViewCellID];
#endif
    [self.tableView registerNib:[UINib nibWithNibName:@"ZKInformationCollectionTableViewCell" bundle:nil] forCellReuseIdentifier:ZKInformationCollectionTableViewCellID];
    
    [self.tableView.mj_header beginRefreshing];
    YJWeakSelf
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
}
#pragma mark   --- 数据请求 ----
/**
 *  重新加载数据
 */
- (void)reloadData
{
    self.page = 1;
    [self requestData];
}
/**
 *  上拉加载数据
 */
- (void)pullLoadingData
{
    self.page++;
    [self requestData];
}
- (void)requestData
{
    self.parameter[@"pageNo"] = [NSNumber numberWithInteger:self.page];
    
    [self.viewMode postDataParameter:self.parameter];
}
#pragma mark ---TBBaseClassViewModeDelegate--
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
    NSArray *data = [ZKInformationCollectionMode mj_objectArrayWithKeyValuesArray:array];
    
    [self.tableView.mj_header endRefreshing];
    if (self.page == 1)
    {
        [self.tableView.mj_footer resetNoMoreData];
        self.tableView.mj_footer.hidden = NO;
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:data];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
        [self.dataArray addObjectsFromArray:data];
    }
    [self  updataTableView];
    [self endDataRequest];
}
/**
 请求出错了
 
 @param error 错误信息
 */
- (void)postError:(NSString *)error;
{
    hudDismiss();
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
/**
 没有更多数据了
 */
- (void)noMoreData;
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}
- (void)endDataRequest
{
}
#pragma mark  ----逻辑区域----
#pragma mark 播放音乐和视频
/**
 播放音乐
 
 @param url URL
 */
- (void)playerVoiceUrl:(NSString *)url
{
    hudShowLoading(@"数据加载中...");
    [self objctDataState:YES];
    //1.获取网络资源路径(URL)
    NSURL *pURL = [NSURL URLWithString:url];
    //2.根据URL创建请求
    NSURLRequest *pRequset = [NSURLRequest requestWithURL:pURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:8];
    [NSURLConnection connectionWithRequest:pRequset delegate:self];
    
}
- (void)voicePlay:(NSData *)data;
{
    [self.play stop];
    self.play = nil;
    self.play.delegate = nil;
    NSError *error;
    
    if (data.length <100)
    {
        hudDismiss();
        [self objctDataState:NO];
        [UIView addMJNotifierWithText:@"音频出错了！" dismissAutomatically:YES];
    }
    else
    {
        self.play = [[AVAudioPlayer alloc] initWithData:data error:&error];
        self.play.delegate = self;
        [self.play prepareToPlay];
        self.play.volume = 1.0f;
        [self.play play];
        hudShowLoading(@"正在播放...");
    }
    
}
/**
 *  🔊对象状态
 *
 *  @param state yes 播放  no停止
 */
- (void)objctDataState:(BOOL)state
{
    NSString *path = state ? @"voice_1.jpg":@"voice_0.jpg";
    [self.voiceImageView setImage:[UIImage imageNamed:path]];
}

/**
 播放视频
 
 @param url url
 */
- (void)playerVideoUrl:(NSString *)url
{
    NSString *path = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DetailViewController *vc =[[DetailViewController alloc] init];
    vc.URLString = path;
    [[ZKUtil getPresentedViewController] presentViewController:vc animated:YES completion:^{
        
    }];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#if guangD
    
    ZKInformationCollectionMode *mode = self.dataArray[section];
    return mode.disposeResult.length == 0? 1:2;
#else
    return 1;
#endif
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0)
    {
        // 信息cell1
        ZKInformationCollectionTableViewCell *cellCollection = [tableView dequeueReusableCellWithIdentifier:ZKInformationCollectionTableViewCellID];
        cellCollection.delegate = self;
        
        if (self.dataArray.count > indexPath.section) {
            
            [cellCollection update:[self.dataArray objectAtIndex:indexPath.section]];
        }
        cell = cellCollection;
        
    }
    else
    {
        // 处理cell
        ZKInformationDealTableViewCell *cellDeal = [tableView dequeueReusableCellWithIdentifier:ZKInformationDealTableViewCellID];
        [cellDeal setPushDealController:^(ZKInformationCollectionMode *mode) {
            
            [self operationEventData:mode];
        }];
        if (self.dataArray.count > indexPath.section)
        {
            cellDeal.mode = self.dataArray[indexPath.section];
        }
        
        cell = cellDeal;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 6;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}
#pragma mark  ----ZKInformationCollectionTableViewCellDelegate----
/**
 *  视频和音频点击事件
 *
 *  @param path 路径
 *  @param type 类型
 */
- (void)clickUrl:(NSString*)path dataType:(NSString*)type objc:(UIImageView*)stateImage;
{
    if ([type isEqualToString:@"voice_0.jpg"])
    {
        self.voiceImageView = stateImage;
        [self playerVoiceUrl:path];
    }
    else
    {
        [self playerVideoUrl:path];
    }
}

/**
 处理事件
 
 @param list 数据
 */
- (void)operationEventData:(ZKInformationCollectionMode *)list;
{
    YJWeakSelf
    ZKDealViewController *vc = [[ZKDealViewController alloc] init];
    vc.mode = list;
    [[ZKUtil getPresentedViewController].navigationController pushViewController:vc animated:YES];
    [vc setUpTableview:^{
        
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
}
#pragma mark  ---NSURLConnectionDelegate--

//1.服务器响应回调的方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.voiceData = nil;
    self.voiceData  = [NSMutableData data];
}
//2.服务返回数据,客户端开始接受(data为返回的数据)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //将返回数据放入缓存区
    [self.voiceData  appendData:data];
}

//3.数据接受完毕回调的方法

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSData *data = [NSData dataWithData:self.voiceData];
    [self voicePlay:data];
}

//4.接受数据失败时候调用的方法

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    hudDismiss();
    [self objctDataState:NO];
    [UIView addMJNotifierWithText:@"网络异常！请检查网络设置." dismissAutomatically:YES];
}

#pragma mark - AVAudioPlayerDelegate

// 音频播放完成时

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)fla
{
    [self objctDataState:NO];
    hudDismiss();
    [UIView addMJNotifierWithText:@"播放完成" dismissAutomatically:YES];
}
// 解码错误

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    
    hudDismiss();
    [UIView addMJNotifierWithText:@"音频出错了！" dismissAutomatically:YES];
    [self objctDataState:NO];
}
// 当音频播放过程中被中断时

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    
    [player pause];
    hudDismiss();
}
// 当中断结束时
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    
    if (player != nil)
    {
        
        [player play];
        hudDismiss();
    }
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

/**
 主线程刷新
 */
- (void)updataTableView
{
    hudDismiss();
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark  ----外部方法----
/**
 更新列表
 */
- (void)updateTheList;
{
    [self.tableView.mj_header beginRefreshing];
}
- (void)dealloc
{
    self.viewMode.delegate = nil;
    self.viewMode = nil;
}
@end
