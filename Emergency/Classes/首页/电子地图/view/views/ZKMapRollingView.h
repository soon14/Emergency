//
//  ZKMapRollingView.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/28.
//  Copyright © 2017年 王小腊. All rights reserved.
//

/**
 滚动视图展示样式
 
 - RollingViewTypeNone: 全部展示
 - RollingViewTypeHotel: 酒店
 - RollingViewTypeTravel: 旅行社
 - RollingViewTypeScenic: 景区
 - RollingViewTypeBus: 大巴
 */
typedef NS_ENUM(NSInteger, RollingViewType) {
    
    RollingViewTypeNone   = 0,
    RollingViewTypeHotel  = 1,
    RollingViewTypeTravel = 2,
    RollingViewTypeScenic = 3,
    RollingViewTypeBus    = 4,
};

#import <UIKit/UIKit.h>

@interface ZKMapRollingView : UIView

/**
 更新数据

 @param array 数据
 @param type 样式
 */
- (void)updataData:(NSMutableArray *)array dataType:(RollingViewType)type;

/**
 是否显示列表按钮
 */
@property (nonatomic, assign) BOOL showListbutton;
@end
