//
//  ZKMapRollingView.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/28.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKMapRollingView.h"
#import "ZKElectronicMapViewMode.h"
#import <iCarousel/iCarousel.h>

#import "ZKICarouselHotelView.h"
#import "ZKICarouselTravelView.h"
#import "ZKICarouselScenicView.h"
#import "ZKICarouselBusView.h"

@interface ZKMapRollingView () <iCarouselDelegate,iCarouselDataSource,ZKICarouselBaseViewDelegate>

@property (nonatomic, strong) NSMutableArray <ZKElectronicMapViewMode *> *dataSource;
// 选中第几个
@property (nonatomic, assign) NSInteger carouselPag;
@property (nonatomic, strong) iCarousel *carouselView;
@property (nonatomic, strong) NSString *className;
@property (nonatomic) RollingViewType viewType;
@property (nonatomic, assign) CGFloat iCarouselWidth;
@property (nonatomic, assign) CGFloat iCarouselHeight;
@end
@implementation ZKMapRollingView

- (NSMutableArray<ZKElectronicMapViewMode *> *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (instancetype)init
{
    if (self = [super init])
    {
        self.userInteractionEnabled = YES;
        self.carouselPag = 0;
        
        self.iCarouselWidth = _SCREEN_WIDTH - 60;
        self.iCarouselHeight = 100;
        self.carouselView = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, self.iCarouselHeight)];
        //设置代理
        self.carouselView.delegate = self;
        self.carouselView.dataSource = self;
        //切换item图片的类型这个是自定义类型
        self.carouselView.type = iCarouselTypeLinear;
        self.carouselView.vertical = NO;
        //第几张图片显示在当前位置
        [self.carouselView scrollToItemAtIndex:0 animated:NO];
        self.carouselView.clipsToBounds = YES;
        //一开始中心图偏移量
        self.carouselView.contentOffset = CGSizeMake(0, 0);
        //类似contentoffset
        self.carouselView.viewpointOffset = CGSizeMake(0, 0);
        //控制滑动切换图片减速的快慢  默认0.95
        self.carouselView.decelerationRate = 0.95;
        [self addSubview:self.carouselView];
        [self.carouselView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(100);
            make.edges.equalTo(self);
        }];
    }
    return self;
}
/**
 更新数据
 
 @param array 数据
 @param type 样式
 */
- (void)updataData:(NSMutableArray *)array dataType:(RollingViewType)type;
{
    // 根据类型修改参数
    if (type == RollingViewTypeNone || type == RollingViewTypeScenic) {
        self.className = @"ZKICarouselScenicView";
        self.iCarouselHeight = 110;
        self.viewType = RollingViewTypeScenic;
    }
    else if (type == RollingViewTypeHotel)
    {
        self.className = @"ZKICarouselHotelView";
        self.iCarouselHeight = 120;
        self.viewType = RollingViewTypeHotel;
    }
    else if (type == RollingViewTypeTravel)
    {
        self.className = @"ZKICarouselTravelView";
        self.iCarouselHeight = 160;
        self.viewType = RollingViewTypeTravel;
    }
    else if (type == RollingViewTypeBus)
    {
        self.className = @"ZKICarouselBusView";
        self.iCarouselHeight = 130;
        self.viewType = RollingViewTypeBus;
    }
    else
    {
        return;
    }
    
    [self.dataSource removeAllObjects];
    if (array.count > 0 || array != nil)
    {
        [self.dataSource addObjectsFromArray:array];
        [self.carouselView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.iCarouselHeight);
        }];
    }
    
    [self.carouselView reloadData];
}
/**
 选中谁
 
 @param index 参数
 */
- (void)selectedCurrentItemIndex:(NSInteger)index;
{
    if (index < self.dataSource.count && index > -1)
    {
        [self.carouselView scrollToItemAtIndex:index animated:YES];
    }
}
#pragma mark  ----ZKiCarouselContenViewDelegate----
- (void)jumpToListViewControllerData:(ZKElectronicMapViewMode *)mode;
{
    if ([self.delegate respondsToSelector:@selector(rollingListButtonClickType:)]) {
        [self.delegate rollingListButtonClickType:self.viewType];
    }
}
#pragma mark -
#pragma mark ----iCarousel methods---

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)[self.dataSource count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    ZKICarouselBaseView *contenView = nil;
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.iCarouselWidth, self.iCarouselHeight)];
        view.backgroundColor = [UIColor whiteColor];
        contenView = [ZKICarouselBaseView accessViewClassName:self.className showListButton:self.showListbutton];
        if (self.showListbutton)
        {
            contenView.delegate = self;
        }
        contenView.tag = 1000;
        [view addSubview:contenView];
        [contenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
    }
    else
    {
        contenView = (ZKICarouselBaseView *)[view viewWithTag:1000];
    }
    
    if (self.dataSource.count > index)
    {
        ZKElectronicMapViewMode *mode = [self.dataSource objectAtIndex:index];
        mode.tag = index + 1;
        [contenView assignmentData:mode];
    }
    
    return view;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 2;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    ZKICarouselBaseView *contenView = nil;
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.iCarouselWidth, self.iCarouselHeight)];
        view.backgroundColor = [UIColor whiteColor];
        contenView = [ZKICarouselBaseView accessViewClassName:self.className showListButton:self.showListbutton];
        contenView.delegate = self;
        contenView.tag = 1000;
        [view addSubview:contenView];
        [contenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
    }
    else
    {
        contenView = (ZKICarouselBaseView *)[view viewWithTag:1000];
    }
    
    return view;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0.0, 1.0, 0.0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.carouselView.itemWidth);
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.03;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carouselView.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    
}
/**
 *  滚动结束
 *
 *  @param carousel -
 */
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel;
{
    NSInteger index = carousel.currentItemIndex;
    
    if ([self.delegate respondsToSelector:@selector(rollingDidEndScrollingCurrentItemIndex:dataType:)] && self.carouselPag != index)
    {
        self.carouselPag = index;// 记录标记 防止循环调用
        [self.delegate rollingDidEndScrollingCurrentItemIndex:index dataType:self.viewType];
    }
}

@end
