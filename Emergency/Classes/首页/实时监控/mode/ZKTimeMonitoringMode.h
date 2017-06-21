//
//  ZKTimeMonitoringMode.h
//  yjPingTai
//
//  Created by 王小腊 on 2017/2/24.
//  Copyright © 2017年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZKTimeMonitoringVideoMode;

@interface ZKTimeMonitoringMode : NSObject

@property (nonatomic, strong) NSMutableArray <ZKTimeMonitoringVideoMode *>*mname;
@property (nonatomic, strong) NSString *name;

- (instancetype)initDictionary:(NSDictionary *)dic;

@end

@interface ZKTimeMonitoringVideoMode: NSObject
//视频名称
@property (nonatomic, strong) NSString *name;
// 视频连接
@property (nonatomic, strong) NSString *url;

- (instancetype)initString:(NSString *)str;
@end
