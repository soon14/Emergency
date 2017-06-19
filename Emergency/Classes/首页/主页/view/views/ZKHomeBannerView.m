//
//  ZKHomeBannerView.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKHomeBannerView.h"
#import "ZKHomeBaseData.h"
#import "ZKHomeBannerData.h"
#import "SDCycleScrollView.h"

@interface ZKHomeBannerView ()<SDCycleScrollViewDelegate>
// 横幅
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) ZKHomeBannerData *bannerData;
@end

@implementation ZKHomeBannerView
- (SDCycleScrollView *)cycleScrollView
{
    
    if (_cycleScrollView == nil) {
        
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        _cycleScrollView.autoScrollTimeInterval = 4;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        _cycleScrollView.delegate = self;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleScrollView.pageControlDotSize = CGSizeMake(3, 3);
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.pageDotColor = [UIColor whiteColor];
        _cycleScrollView.titleLabelBackgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _cycleScrollView.titleLabelTextColor =[UIColor whiteColor];
        _cycleScrollView.titleLabelTextFont = [UIFont systemFontOfSize:10];
    }
    
    return _cycleScrollView;
}
- (instancetype)init
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self postBannerData];
        
    }
    return self;
}
#pragma mark  ----横幅数据请求----
- (void)postBannerData
{
    YJWeakSelf
    [ZKPostHttp post:@"appScencyImage/scencyImageList?pageNo=1&pageSize=100" params:nil cacheType:ZKCacheTypeReturnCacheDataElseLoad success:^(NSDictionary *obj) {
        [weakSelf imageData:obj];
    } failure:^(NSError *error) {
        hudShowError(@"图片请求出错了");
    }];

}
#pragma mark  ----图片浏览器----
- (void)imageData:(NSDictionary *)obj
{
     self.bannerData = [ZKHomeBannerData mj_objectWithKeyValues:obj];

    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:self.bannerData.total];
    NSMutableArray *nameArray  = [NSMutableArray arrayWithCapacity:self.bannerData.total];

    [self.bannerData.data enumerateObjectsUsingBlock:^(ZKHomeImagesData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        NSURL *imageUrl = [[NSURL alloc] initWithString:[obj.urlphoto stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [imageArray addObject:imageUrl];
        [nameArray addObject:obj.name];
        
    }];
    if (imageArray.count != 0)
    {
        [self addSubview:self.cycleScrollView];
        self.cycleScrollView.imageURLStringsGroup = imageArray;
        self.cycleScrollView.titlesGroup = nameArray;
        
        [self setBannerFrame];
    }

}
//  重新更新banner尺寸
- (void)setBannerFrame
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
     
        YJWeakSelf
        [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        
        
        float imageHeghit = 308*_SCREEN_WIDTH/720;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(imageHeghit);
            }];
            [self layoutIfNeeded];
        }];
        
    }];
}
#pragma mark  ----SDCycleScrollViewDelegate----
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
{
    if (index<self.bannerData.data.count)
    {
//        ZKHomeImagesData *data = [self.bannerData.data objectAtIndex:index];
   
    }
}
@end
