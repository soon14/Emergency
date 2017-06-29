//
//  ZKResourceStatViewController.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/22.
//  Copyright © 2017年 王小腊. All rights reserved.
//


/**
 资源统计类型

 - ResourceStatTypeHotel: 酒店
 - ResourceStatTypeTravel: 旅行社
 - ResourceStatTypeScenic: 景区
 - ResourceStatTypeGuide: 导游
 */
typedef NS_ENUM(NSInteger,ResourceStatType) {

    ResourceStatTypeHotel  = 1,

    ResourceStatTypeTravel = 2,

    ResourceStatTypeScenic = 3,
    
    ResourceStatTypeGuide  = 4
    
};

#import "ZKTableBaseViewController.h"

/**
 资源统计列表
 */
@interface ZKResourceStatViewController : ZKTableBaseViewController

/**
 配置数据
 
 @param type 资源类型
 @param defaultData 按钮默认值 @{@"left":@"-",@"region":@"-", @"right":@"-",@"level":@"-"}
  @param isMap 是否地图跳转过来的
 */
- (void)configurationDataSearchType:(ResourceStatType)type buttonDefaultData:(NSDictionary *)defaultData isMap:(BOOL)isMap;

@end
