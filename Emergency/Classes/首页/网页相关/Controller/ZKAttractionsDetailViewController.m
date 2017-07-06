//
//  ZKAttractionsDetailViewController.m
//  Emergency
//
//  Created by 王小腊 on 2017/7/6.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKAttractionsDetailViewController.h"
#import "ZKBaseWebViewController.h"
#import "ZKMeteorologicalDataViewController.h"
#import "KxMovieViewController.h"
#import "ZKTimeMonitoringReusableView.h"
#import "ZKMonitoringCollectionViewCell.h"
#import "ZKAttractionsDetailViewMode.h"

@interface ZKAttractionsDetailViewController ()<AttractionsDetailViewModeDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
//天气
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
//气象数据
@property (weak, nonatomic) IBOutlet UILabel *meteorologicalLabel;
@property (weak, nonatomic) IBOutlet UILabel *realLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxpeopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *allpeopleLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) ZKAttractionsDetailViewMode *viewMode;
@property (nonatomic, strong) NSMutableDictionary *parameter;

@property (nonatomic, strong) NSArray <ZKTimeMonitoringMode *>* videoArray;
// 景区详情数据
@property (nonatomic, strong) ZKAttractionsDetailList *detailList;
@end

@implementation ZKAttractionsDetailViewController
- (NSMutableDictionary *)parameter
{
    if (!_parameter)
    {
        _parameter = [NSMutableDictionary dictionary];
    }
    return _parameter;
}
- (ZKAttractionsDetailViewMode *)viewMode
{
    if (!_viewMode)
    {
        _viewMode = [[ZKAttractionsDetailViewMode alloc] init];
        _viewMode.delegate = self;
    }
    return _viewMode;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"数据正在加载...";
    [self setUpView];
    [self initData];
}
#pragma mark  ----数据配置----
- (void)setUpView
{
   UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    layOut.headerReferenceSize = CGSizeMake(_SCREEN_WIDTH-32, 40);
    layOut.minimumLineSpacing = 0.0f;
    layOut.minimumInteritemSpacing = 0.0f;
    
    self.collectionView.collectionViewLayout = layOut;
    //设置为总能垂直滑动就OK了。
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = YES;
    [self.collectionView registerClass:[ZKMonitoringCollectionViewCell class] forCellWithReuseIdentifier:@"ZKMonitoringCollectionViewCellID"];
    [self.collectionView registerClass:[ZKTimeMonitoringReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];

}
- (void)initData
{
    [self.parameter setValue:self.resourcecode forKey:@"resourcecode"];
    [self.viewMode startRequestAllData:self.parameter];
}


#pragma mark  ----AttractionsDetailViewModeDelegate----
/**
 景区详情回调
 
 @param list 数据
 */
- (void)attractionsDetailData:(ZKAttractionsDetailList *)list;
{
    self.detailList = list;
    
    [ZKUtil downloadImage:self.bannerImageView imageUrl:list.urlphoto duImageName:@"banner"];
    self.navigationItem.title = list.name;
    self.weatherLabel.text = list.wt;
    self.meteorologicalLabel.text = [NSString stringWithFormat:@"%@~%@° %@",list.t1,list.t2,list.wind];
    self.realLabel.text = [NSString stringWithFormat:@"%@",list.real];
    self.maxpeopleLabel.text = [NSString stringWithFormat:@"%@",list.maxpeople];
    self.allpeopleLabel.text = [NSString stringWithFormat:@"%@",list.allpeople];
}
/**
 视频数据回调
 
 @param list 数据
 */
- (void)attractionsVideoData:(NSArray <ZKTimeMonitoringMode *> *)list;
{
    self.videoArray = list;
    [self.collectionView reloadData];
}
#pragma mark  ----UICollectionViewDelegate----
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.videoArray.count == 0)
    {
        return 0;
    }
    ZKTimeMonitoringMode *mode = self.videoArray[section];
    return mode.mname.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZKMonitoringCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZKMonitoringCollectionViewCellID" forIndexPath:indexPath];
    
    if (self.videoArray.count > 0)
    {
        ZKTimeMonitoringMode *mode = self.videoArray[indexPath.section];
        ZKTimeMonitoringVideoMode *list = mode.mname[indexPath.row];
        [cell updata:list];
    }
    
    [cell setVideoButtonClick:^(NSString *url) {
        
        [self playerVideoUrl:url];
        
    }];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((_SCREEN_WIDTH - 32) / 2, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(_SCREEN_WIDTH - 32, 40);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        

        ZKTimeMonitoringReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        NSString *title = @"监控视频 (共0个)";
        if (self.videoArray.count != 0 )
        {
            ZKTimeMonitoringMode *mode = self.videoArray[indexPath.section];
            title = [NSString stringWithFormat:@"监控视频 (共%lu个)",(unsigned long)mode.mname.count];
        }
        
        [headerView updataTitle:title];
        reusableview = headerView;
    }
    
    return reusableview;
}
#pragma mark  ----监控播放----
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
#pragma mark  ----按钮点击事件----
- (IBAction)goWeatherDetail:(UIButton *)sender
{
    ZKMeteorologicalDataViewController *vc = [ZKMeteorologicalDataViewController alloc];
    vc.resourcecode = self.resourcecode;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goRealTimeNumber:(UIButton *)sender
{
    if (self.detailList)
    {
        NSURL *URL = [[NSBundle mainBundle] URLForResource:@"assets/web/scenicreal" withExtension:@"html"];
        NSString *str = [URL absoluteString];
        NSString *urlSuffix = [NSString stringWithFormat:@"%@?resourcecode=%@&sceneryName=%@",str,self.detailList.resourcecode,self.detailList.name];
        ZKBaseWebViewController *web = [[ZKBaseWebViewController alloc] init];
        web.pathUrl = [NSURL URLWithString:[urlSuffix stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        web.htmlTitle = self.detailList.name;
        [self.navigationController pushViewController:web animated:YES];
    }
    else
    {
        [UIView addMJNotifierWithText:@"数据还未加载!" dismissAutomatically:YES];
    }

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
