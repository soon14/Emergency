//
//  ZKInformationCollectionMode.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/30.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKInformationCollectionMode : NSObject
//appEmergency/emergencyList
@property(nonatomic, strong) NSString *audio;//音频
@property(nonatomic, strong) NSString *content;//事件描述
@property(nonatomic, strong) NSString *name;//标题
@property(nonatomic, strong) NSString *phone;//联系方式
@property(nonatomic, strong) NSString *reporttime;//上报时间
@property(nonatomic, strong) NSString *reportyeo;//上报人
@property(nonatomic, strong) NSString *scencyName;//景区名称
@property(nonatomic, strong) NSString *unit;//景区资源编码
@property(nonatomic, strong) NSString *video;//视频
@property(nonatomic, retain) NSArray  *image;//图片
@property(nonatomic, strong) NSString *latitude;//纬度
@property(nonatomic, strong) NSString *longitude;//经度
@property(nonatomic, strong) NSString *disposeTime;//处理时间
@property(nonatomic, strong) NSString *disposeResult;//处理内容
@property(nonatomic, strong) NSString *ID;//事件ID

@end
