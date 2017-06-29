//
//  ZKElectronicMapViewMode.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/28.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKElectronicMapViewMode : NSObject

@property (nonatomic, strong) NSString *address;//地址
@property (nonatomic, strong) NSString *contactor;//联系人
@property (nonatomic, strong) NSString *levels;//等级
@property (nonatomic, strong) NSString *name;//名称
@property (nonatomic, strong) NSString *phone;//联系电话
@property (nonatomic, strong) NSString *region_id;//地区编码
@property (nonatomic, strong) NSString *resourcecode;//资源编码
@property (nonatomic, strong) NSString *amount;//带团人数
@property (nonatomic, strong) NSString *teamtotal;//团队数
//@property (nonatomic, strong) NSString *ID;// id
@property (nonatomic, strong) NSString *maxBearing;//最大承载量
@property (nonatomic, strong) NSString *real;//人数
@property (nonatomic, strong) NSString *arrivetime;//出发时间
@property (nonatomic, strong) NSString *busnum;//大巴车牌
@property (nonatomic, assign) double   coordinate_x;//经度
@property (nonatomic, assign) double   coordinate_y;//纬度
@property (nonatomic, strong) NSString *guname;//导游名称
@property (nonatomic, strong) NSString *guphone;//	联系电话
@property (nonatomic, strong) NSString *leavetime;//结束时间
@property (nonatomic, strong) NSString *speed;//速度
@property (nonatomic, strong) NSString *tname;//团队名称
@property (nonatomic, strong) NSString *tournum;//团队编号

@end
