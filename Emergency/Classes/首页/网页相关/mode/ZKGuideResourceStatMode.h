//
//  ZKGuideResourceStatMode.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/23.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 导游模型
 */
@interface ZKGuideResourceStatMode : NSObject

@property (nonatomic, strong) NSString *guidecardno;//导游卡号
@property (nonatomic, strong) NSString *levels;//等级
@property (nonatomic, strong) NSString *name;//名字
@property (nonatomic, strong) NSString *phone;//联系电话
@property (nonatomic, strong) NSString *photo;//照片
@property (nonatomic, strong) NSString *qualificationscard;//资格证号
@property (nonatomic, strong) NSString *tname;//团队名称
@property (nonatomic, strong) NSString *tourcard;//导游证号
@property (nonatomic, strong) NSString *travel;//所属旅行社

@end
