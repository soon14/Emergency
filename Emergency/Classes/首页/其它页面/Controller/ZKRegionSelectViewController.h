//
//  ZKRegionSelectViewController.h
//  Emergency
//
//  Created by 王小腊 on 2017/7/5.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKBaseViewController.h"

/**
 地点选择
 */
@interface ZKRegionSelectViewController : ZKBaseViewController
/**
 当前定位地区
 */
@property (strong, nonatomic) NSString *locationName;

/**
 选择回调
 */
@property (copy, nonatomic) void (^selectData)(NSString *selectKey, BOOL isCity);

@end
