//
//  ZKTourismDataViewController.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/24.
//  Copyright © 2017年 王小腊. All rights reserved.
//

/**
 旅行数据类型
 
 - TourismDataTypeTeam: 团队
 - TourismDataTypeBusShowMap: 大巴带地图按钮
 - TourismDataTypeBusNone: 大巴
 */
typedef NS_ENUM(NSInteger, TourismDataType)
{
    TourismDataTypeTeam = 0,
    TourismDataTypeBusShowMapBuuton,
    TourismDataTypeBusNone
    
};
#import "ZKTableBaseViewController.h"
/**
 旅游数据
 */
@interface ZKTourismDataViewController : ZKTableBaseViewController

/**
 旅游数据类型
 */
@property (nonatomic) TourismDataType tourismDataType;
@end
