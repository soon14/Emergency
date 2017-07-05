//
//  ZKMeteorologicalTableViewCell.h
//  Emergency
//
//  Created by 王小腊 on 2017/7/5.
//  Copyright © 2017年 王小腊. All rights reserved.
//

extern NSString *const ZKMeteorologicalTableViewCellID;

#import <UIKit/UIKit.h>
@class ZKMeteorologicalWeather;

@interface ZKMeteorologicalTableViewCell : UITableViewCell

/**
 cell赋值

 @param root 数据
 @param date 日期
 @param state 白天还是黑夜
 @param index 第几个
 */
- (void)assignmentData:(ZKMeteorologicalWeather *)root date:(NSString *)date dayState:(BOOL)state cellIndex:(NSInteger)index;

@end
