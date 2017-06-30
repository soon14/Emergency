//
//  ZKICarouselBaseView.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/29.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKElectronicMapViewMode.h"

@protocol ZKICarouselBaseViewDelegate <NSObject>

- (void)jumpToListViewControllerData:(ZKElectronicMapViewMode *)mode;

@end
@interface ZKICarouselBaseView : UIView

@property (nonatomic, strong) ZKElectronicMapViewMode *mapList;

/**
 赋值
 
 @param list 数据
 RollingViewTypeHotel  = 1,
 RollingViewTypeTravel = 2,
 RollingViewTypeScenic = 3,
 RollingViewTypeBus    = 4,
 
 */
- (void)assignmentData:(ZKElectronicMapViewMode *)list;

/**
 获取view

 @param name 类名
 @param show 是否显示列表按钮
 @return self
 */
+ (id)accessViewClassName:(NSString *)name showListButton:(BOOL)show;

@property(nonatomic, assign) id<ZKICarouselBaseViewDelegate>delegate;

@end
