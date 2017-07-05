//
//  ZKMeteorologicalESRootClass.h
//  Emergency
//
//  Created by 王小腊 on 2017/7/4.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZKMeteorologicalEnvironmental,ZKMeteorologicalWeather;
@interface ZKMeteorologicalESRootClass : NSObject
// 城市名称
@property (nonatomic, copy) NSString *district;
// 所在景区
@property (nonatomic, copy) NSString *scency;
// 所在省市
@property (nonatomic, copy) NSString *province;
// 环保
@property (nonatomic, strong) ZKMeteorologicalEnvironmental *environmental;
// 天气
@property (nonatomic, strong) NSArray<ZKMeteorologicalWeather *> *weather;

@end


@interface ZKMeteorologicalEnvironmental : NSObject
// 空气质量
@property (nonatomic, copy) NSString *qlty;
// 细颗粒物
@property (nonatomic, copy) NSString *pm25;
// 空气质量指数
@property (nonatomic, copy) NSString *aqi;
// 二氧化氮
@property (nonatomic, copy) NSString *no2;
// 臭氧
@property (nonatomic, copy) NSString *o3;
// 二氧化硫
@property (nonatomic, copy) NSString *so2;
// 可吸入颗粒物
@property (nonatomic, copy) NSString *pm10;
// 一氧化碳
@property (nonatomic, copy) NSString *co;

@end

@interface ZKMeteorologicalWeather : NSObject
// 白天天气图标地址
@property (nonatomic, copy) NSString *pic_d;
// 风力风向
@property (nonatomic, copy) NSString *wind;
// 最低气温
@property (nonatomic, copy) NSString *min;
// 夜间天气描述
@property (nonatomic, copy) NSString *txt_n;
// 夜间天气图标地址
@property (nonatomic, copy) NSString *pic_n;
// 天气预报时间
@property (nonatomic, copy) NSString *date;
// 星期
@property (nonatomic, copy) NSString *week;
//
@property (nonatomic, copy) NSString *unicode_n;
// 最高气温
@property (nonatomic, copy) NSString *max;
// 白天天气描述
@property (nonatomic, copy) NSString *txt_d;
//
@property (nonatomic, copy) NSString *unicode_d;

@end


