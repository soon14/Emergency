//
//  ZKBusTrajectoryMode.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/26.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKBusTrajectoryMode : NSObject

@property(nonatomic, strong) NSString *btime;//时间
@property(nonatomic, strong) NSString *busnum;//车牌号
@property(nonatomic, assign) double   coordinate_x;//经度
@property(nonatomic, assign) double   coordinate_y;//纬度
@property(nonatomic, strong) NSString *speed;//速度

@property(nonatomic, strong) NSString *address;//地址

@end
