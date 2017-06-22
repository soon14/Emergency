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
 资源等级展示字符
 */
@property (nonatomic, strong) NSString *resourceLevel;

/**
 资源等级搜索类型
 */
@property (nonatomic, strong) NSString *resourceViewType;


@property (nonatomic) ResourceStatType resourceStatType;

@end
