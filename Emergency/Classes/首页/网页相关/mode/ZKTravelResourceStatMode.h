//
//  ZKTravelResourceStatMode.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/23.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 旅行社模型
 */
@interface ZKTravelResourceStatMode : NSObject

@property (nonatomic, strong) NSString *address;//地址
@property (nonatomic, strong) NSString *amount;//带团人数
@property (nonatomic, strong) NSString *contactor;//联系人
@property (nonatomic, strong) NSString *coordinate_x;//经度
@property (nonatomic, strong) NSString *coordinate_y;//纬度
@property (nonatomic, strong) NSString *levels;//类型
@property (nonatomic, strong) NSString *name;//名称
@property (nonatomic, strong) NSString *phone;//联系电话
@property (nonatomic, strong) NSString *region_id;//地区编码
@property (nonatomic, strong) NSString *resourcecode;//资源编码
@property (nonatomic, strong) NSString *teamtotal;//团队数

@end
