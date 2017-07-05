//
//  ZKRegionSelectMode.h
//  Emergency
//
//  Created by 王小腊 on 2017/7/5.
//  Copyright © 2017年 王小腊. All rights reserved.
//

extern NSString *const historicalDataKey;

#import <Foundation/Foundation.h>
#import "ZKScenicResourceStatMode.h"

@class ZKRegionSelectCityMode,ZKRegionSelectScenicSpotMode;

@interface ZKRegionSelectMode : NSObject
/**
 城市数据
 */
@property (nonatomic, strong) NSArray <ZKRegionSelectCityMode *>*cityArray;

/**
  热门景点数据
 */
@property (nonatomic, strong) NSArray <ZKRegionSelectScenicSpotMode *>*scenicSpotArray;

/**
 搜索数据
 */
@property (nonatomic, strong) NSArray <ZKScenicResourceStatMode *>*searchData;
/**
 历史搜索数据
 */
@property (nonatomic, strong) NSMutableArray *historicalData;

/**
  保存搜索历史

 @param key 搜索字段
 @param successful 回调
 */
- (void)saveSearchHistoryData:(NSString *)key successful:(void(^)(BOOL saveState))successful;

/**
 清空历史数据
 
 @param successful 回调
 */
- (void)emptyHistoryDataSuccessful:(void(^)(BOOL saveState))successful;
@end

@interface ZKRegionSelectCityMode : NSObject
// 城市名称
@property (nonatomic, strong) NSString *cityname;
// 地区代码
@property (nonatomic, strong) NSString *region;
@end

@interface ZKRegionSelectScenicSpotMode : NSObject
// 资源编码
@property (nonatomic, strong) NSString *resourcecode;
// 景区名称
@property (nonatomic, strong) NSString *sname;
//// 景区ID
//@property (nonatomic, strong) NSString *ID;
// 地区编码
@property (nonatomic, strong) NSString *region;


@end
