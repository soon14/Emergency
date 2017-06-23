//
//  ZKScenicResourceStatMode.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/23.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 景区模型
 */
@interface ZKScenicResourceStatMode : NSObject

@property (nonatomic, strong) NSString *address;//地址
@property (nonatomic, strong) NSString *coordinate_x;//经度
@property (nonatomic, strong) NSString *coordinate_y;//纬度
@property (nonatomic, strong) NSString *ID;// id
@property (nonatomic, strong) NSString *levels;//等级
@property (nonatomic, strong) NSString *maxBearing;//最大承载量
@property (nonatomic, strong) NSString *name;//名称
@property (nonatomic, strong) NSString *real;//人数
@property (nonatomic, strong) NSString *region_id;//地区编码
@property (nonatomic, strong) NSString *resourcecode;//资源编码

@end
