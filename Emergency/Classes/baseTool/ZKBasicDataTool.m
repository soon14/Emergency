//
//  ZKBasicDataTool.m
//  yjPingTai
//
//  Created by 王小腊 on 2017/2/24.
//  Copyright © 2017年 WangXiaoLa. All rights reserved.
//

/**
 等级类型
 
 - DictTypeOnlineR: 票务类型
 - DictTypeGuideLevel_0: 导游等级
 - DictTypeHotelStarLevel_0: 酒店等级
 - DictTypeTravelLevel_0: 旅行社类型
 - DictTypeViewType_0: 景区等级
 */
typedef NS_ENUM(NSInteger, DictType) {
    
    DictTypeOnlineR  = 0,
    DictTypeGuideLevel_0,
    DictTypeHotelStarLevel_0,
    DictTypeTravelLevel_0,
    DictTypeViewType_0,
    
};

#import "ZKBasicDataTool.h"

@implementation ZKBasicDataTool
{
    NSArray *_onlineArray;//slevelstr等级名称
    NSArray *_levelstrArray;//levelstr等级名称
    NSArray *_guideArray;//导游
    NSArray *_htypeArray;//酒店
    NSArray *_typetravelArray;//旅行社类型
    NSArray *_city_0_array;
    NSArray *_city_1_array;
    NSArray *_monitoringArray;
    NSArray *_scenicSpotArray;
    DictType postType;
    
}

+ (ZKBasicDataTool *)sharedManager
{
    static ZKBasicDataTool *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
/**
 票务类型
 
 @param array
 */
- (void)obtainOnline:(void(^)(NSArray *onlineArray))array;
{
    [self postDataType:DictTypeOnlineR success:^(NSArray *data) {
        
        _onlineArray = data;
        array(data);
    }];
}
/**
 slevelstr等级名称
 
 @param array
 */
- (void)obtainLevelstrArray:(void(^)(NSArray *levelstrArray))array;
{
    [self postDataType:DictTypeViewType_0 success:^(NSArray *data)
    {
        _levelstrArray = data;
        array(data);
    }];
}

/**
 导游
 
 @param array
 */
- (void)obtainGuideArray:(void(^)(NSArray *guideArray))array;
{
    [self postDataType:DictTypeGuideLevel_0 success:^(NSArray *data) {
        
        _guideArray = data;
        array(data);
    }];
    
}
/**
 酒店
 
 @param array
 */
- (void)obtainHtypeArray:(void(^)(NSArray *htypeArray))array;
{
    [self postDataType:DictTypeHotelStarLevel_0 success:^(NSArray *data) {
        
        _htypeArray = data;
        array(data);
    }];
}
/**
 旅行社类型
 
 @param array
 */
- (void)obtainTypetravelArray:(void(^)(NSArray *typetravelArray))array;
{
    [self postDataType:DictTypeTravelLevel_0 success:^(NSArray *data) {
        
        _typetravelArray = data;
        array(data);
    }];
}
/**
 城市数据 0
 
 @param array
 */
- (void)obtainCityOne:(void(^)(NSArray *cityOne))array;
{
    NSString *path = [NSString stringWithFormat:@"%@appRegion/regionList",POST_URL];
    if (_city_0_array.count>0)
    {
        array(_city_0_array);
    }
    else
    {
        [ZKPostHttp get:path params:nil success:^(id responseObj) {
            
            _city_0_array = [responseObj valueForKey:@"data"];
            
            array(_city_0_array);
            
        } failure:nil];
    }
    
}
/**
 城市数据 1
 
 @param array
 */
- (void)obtainCityTwo:(void(^)(NSArray *cityTwo))array;
{
    NSString *path = [NSString stringWithFormat:@"%@appVideo/videoCountByCity",POST_URL];
    if (_city_1_array.count>0)
    {
        array(_city_1_array);
    }
    else
    {
        [ZKPostHttp get:path params:nil success:^(id responseObj)
         {
             _city_1_array = [responseObj valueForKey:@"data"];
             
             array(_city_1_array);
             
             
         } failure:nil];
    }
    
}
- (void)obtainMonitringCityData:(void(^)(NSArray *cityData))array;
{
    NSString *path = [NSString stringWithFormat:@"%@appVideo/videoCountByCityForNew",POST_URL];
    if (_monitoringArray.count>0)
    {
        array(_monitoringArray);
    }
    else
    {
        [ZKPostHttp get:path params:nil success:^(id responseObj)
         {
             _monitoringArray = [[responseObj valueForKey:@"data"] valueForKey:@"rows"];
             array(_monitoringArray);
             
             
         } failure:nil];
    }
    
}
/**
 热门景区数据
 
 @param array 数据
 */
- (void)obtainHotScenicSpotData:(void(^)(NSArray *scenicSpotData))array;
{
    NSString *path = [NSString stringWithFormat:@"%@appScency/hotScencyList",POST_URL];
    if (_scenicSpotArray.count > 0)
    {
        array(_scenicSpotArray);
    }
    else
    {
        [ZKPostHttp get:path params:nil success:^(id responseObj)
         {
             _scenicSpotArray = [responseObj valueForKey:@"data"];
             array(_scenicSpotArray);
             
             
         } failure:nil];
    }

}
- (void)postDataType:(DictType)type success:(void(^)(NSArray *data))success
{
    NSArray *contenArray;
    NSString *url;
    switch (type)
    {
        case DictTypeOnlineR:
            contenArray = _onlineArray;
            url = @"pkey=OnlineR";
            break;
        case DictTypeGuideLevel_0:
            contenArray = _guideArray;
            url = @"pkey=guideLevel_0";
            break;
        case DictTypeHotelStarLevel_0:
            contenArray = _htypeArray;
            url = @"pkey=hotelStarLevel_0";
            break;
        case DictTypeTravelLevel_0:
            contenArray = _typetravelArray;
            url = @"pkey=travelLevel_0";
            break;
        case DictTypeViewType_0:
            contenArray = _levelstrArray;
            url = @"pkey=viewType_0";
            break;
            
        default:
            break;
    }
    if (contenArray.count >0)
    {
        success(contenArray);
    }
    else
    {
        NSString *path = [NSString stringWithFormat:@"%@appDict/dictType?%@",POST_URL,url];
        [ZKPostHttp get:path params:nil success:^(id responseObj) {
            
            NSArray *data = [responseObj valueForKey:@"data"];
            
            success(data);
            
        } failure:nil];
        
    }
    
}

@end
