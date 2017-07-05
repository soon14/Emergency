//
//  ZKRegionSelectMode.m
//  Emergency
//
//  Created by 王小腊 on 2017/7/5.
//  Copyright © 2017年 王小腊. All rights reserved.
//

NSString *const historicalDataKey = @"historicalDataKey";

#import "ZKRegionSelectMode.h"

@implementation ZKRegionSelectMode

- (NSMutableArray *)historicalData
{
    if (!_historicalData)
    {
        _historicalData = [NSMutableArray array];
    }
    return _historicalData;
}
- (instancetype)init
{
    if (self = [super init])
    {
        NSString *path = [kCachePath stringByAppendingPathComponent:historicalDataKey];
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
        if (array.count > 0)
        {
            [self.historicalData removeAllObjects];
            [self.historicalData addObjectsFromArray:array];
        }
    }
    return self;
}
/**
 保存搜索历史
 
 @param key 搜索字段
 @param successful 回调
 */
- (void)saveSearchHistoryData:(NSString *)key successful:(void(^)(BOOL saveState))successful;
{
    if (key.length == 0 )
    {
        return;
    }
    // 防止保存同一数据
    [self.historicalData removeObject:key];
    // 重新添加
    [self.historicalData addObject:key];
    // 异步保存
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSString *path = [kCachePath stringByAppendingPathComponent:historicalDataKey];
        BOOL state = [self.historicalData.copy writeToFile:path atomically:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (successful)
            {
                successful(state);
            }
        });
    });
    
}
/**
 清空历史数据
 
 @param successful 回调
 */
- (void)emptyHistoryDataSuccessful:(void(^)(BOOL saveState))successful;
{
    [self.historicalData removeAllObjects];
    // 异步保存
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *path = [kCachePath stringByAppendingPathComponent:historicalDataKey];
        BOOL state = [self.historicalData.copy writeToFile:path atomically:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (successful)
            {
                successful(state);
            }
        });
    });

}
@end

@implementation ZKRegionSelectCityMode



@end
@implementation ZKRegionSelectScenicSpotMode



@end
