//
//  ZKHotelResourceStatMode.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/23.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 酒店模型
 */
@interface ZKHotelResourceStatMode : NSObject

@property (nonatomic, strong) NSString *address;//地址
@property (nonatomic, strong) NSString *contactor;//联系人
@property (nonatomic, strong) NSString *coordinate_x;//经度
@property (nonatomic, strong) NSString *coordinate_y;//纬度
@property (nonatomic, strong) NSString *levels;//等级
@property (nonatomic, strong) NSString *name;//名称
@property (nonatomic, strong) NSString *phone;//联系电话
@property (nonatomic, strong) NSString *region_id;//地区编码
@property (nonatomic, strong) NSString *resourcecode;//资源编码

@end
