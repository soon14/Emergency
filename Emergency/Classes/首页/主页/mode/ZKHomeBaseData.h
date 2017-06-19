//
//  ZKHomeBaseData.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

static NSString *const ZKHomeCellOrder_key = @"ZKHomeCellOrder_key";

#import <Foundation/Foundation.h>

@interface ZKHomeBaseData : NSObject

/**
 基础数据请求
 */
+ (void)basicDataRequest;

/**
 主页加载的内容数据

 @return 数据
 */
+ (NSArray <NSDictionary *>*)homeContentData;

@end
