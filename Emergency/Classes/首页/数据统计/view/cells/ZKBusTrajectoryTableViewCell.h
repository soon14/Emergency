//
//  ZKBusTrajectoryTableViewCell.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/27.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKBusTrajectoryMode;

@interface ZKBusTrajectoryTableViewCell : UITableViewCell


/**
 cell赋值

 @param list 数据
 */
- (void)cellAssignmentData:(ZKBusTrajectoryMode *)list;

@end
