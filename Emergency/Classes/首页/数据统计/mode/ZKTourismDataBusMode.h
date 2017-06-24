//
//  ZKTourismDataBusMode.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/24.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKTourismDataBusMode : NSObject

@property (nonatomic, strong) NSString *amount;//人数
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
