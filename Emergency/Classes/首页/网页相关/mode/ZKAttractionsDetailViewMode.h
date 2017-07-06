//
//  ZKAttractionsDetailViewMode.h
//  Emergency
//
//  Created by 王小腊 on 2017/7/6.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKTimeMonitoringMode.h"
@class ZKAttractionsDetailList,ZKAttractionsVideoList;

@protocol AttractionsDetailViewModeDelegate <NSObject>
@optional

/**
 景区详情回调

 @param list 数据
 */
- (void)attractionsDetailData:(ZKAttractionsDetailList *)list;


/**
 视频数据回调

 @param list 数据
 */
- (void)attractionsVideoData:(NSArray <ZKTimeMonitoringMode *> *)list;

@end
@interface ZKAttractionsDetailViewMode : NSObject

/**
 开始请求所有数据

 @param parameter 参数
 */
- (void)startRequestAllData:(NSMutableDictionary *)parameter;

/**
 请求景区详情数据
 */
- (void)requestScencyDetailsData;

/**
 请求视频数据
 */
- (void)requestVideoData;

@property (nonatomic, assign) id<AttractionsDetailViewModeDelegate>delegate;

@end

@interface ZKAttractionsDetailList : NSObject

@property (nonatomic, strong) NSString *allpeople; //今日人数
@property (nonatomic, strong) NSString *cityname; //景区所在城市
@property (nonatomic, strong) NSString *maxpeople; //最大承载量
@property (nonatomic, strong) NSString *name; //景区名称
@property (nonatomic, strong) NSString *real; //当前入园人数
@property (nonatomic, strong) NSString *regionid; //地区编码
@property (nonatomic, strong) NSString *resourcecode; //资源编码
@property (nonatomic, strong) NSString *t1; //最低气温
@property (nonatomic, strong) NSString *t2; //最高气温
@property (nonatomic, strong) NSString *urlphoto; //景区图片
@property (nonatomic, strong) NSString *wind;//风速风力
@property (nonatomic, strong) NSString *wt;//天气描述
@end

