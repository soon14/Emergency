//
//  ZKBasicDataTool.h
//  yjPingTai
//
//  Created by 王小腊 on 2017/2/24.
//  Copyright © 2017年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKBasicDataTool : NSObject

/**
 创建单利 基础数据

 @return self
 */
+ (ZKBasicDataTool *)sharedManager;

/**
 首页banner图片数组
 */
@property (nonatomic, strong) NSArray *homeScenicArray;
/**
 票务类型

 @param array 数据
 */
- (void)obtainOnline:(void(^)(NSArray *onlineArray))array;
/**
 slevelstr等级名称

 @param array 数据
 */
- (void)obtainLevelstrArray:(void(^)(NSArray *levelstrArray))array;

/**
 导游

 @param array 数据
 */
- (void)obtainGuideArray:(void(^)(NSArray *guideArray))array;

/**
 酒店

 @param array 数据
 */
- (void)obtainHtypeArray:(void(^)(NSArray *htypeArray))array;

/**
 旅行社类型

 @param array 数据
 */
- (void)obtainTypetravelArray:(void(^)(NSArray *typetravelArray))array;

/**
 城市数据 景区

 @param array 数据
 */
- (void)obtainCityOne:(void(^)(NSArray *cityOne))array;

/**
 城市数据 监控

 @param array 数据
 */
- (void)obtainCityTwo:(void(^)(NSArray *cityTwo))array;

/**
 乐山用 - 分级城市选择

 @param array 数据
 */
- (void)obtainMonitringCityData:(void(^)(NSArray *cityData))array;

/**
 热门景区数据

 @param array 数据
 */
- (void)obtainHotScenicSpotData:(void(^)(NSArray *scenicSpotData))array;

@end
