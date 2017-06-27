//
//  ZKElectronicMapViewController.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/27.
//  Copyright © 2017年 王小腊. All rights reserved.
//


/**
 地图展示样式

 - ElectronicMapTypeNone: 全部展示
 - ElectronicMapTypeHotel: 酒店
 - ElectronicMapTypeTravel: 旅行社
 - ElectronicMapTypeScenic: 景区
 - ElectronicMapTypeGuide: 导游
 */
typedef NS_ENUM(NSInteger, ElectronicMapType) {

    ElectronicMapTypeNone   = 0,
    ElectronicMapTypeHotel  = 1,
    ElectronicMapTypeTravel = 2,
    ElectronicMapTypeScenic = 3,
    ElectronicMapTypeGuide  = 4,
};
#import "ZKBaseViewController.h"

/**
 电子地图
 */
@interface ZKElectronicMapViewController : ZKBaseViewController

/**
 地图配置数据
 
 @param type 资源类型
 @param defaultData 按钮默认值 @{@"left":@"-",@"region":@"-", @"right":@"-",@"level":@"-"}
 */
- (void)mapConfigurationType:(ElectronicMapType)type dataDefaultData:(NSDictionary *)defaultData;

@end
