//
//  ZKTourismDataBusCell.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/24.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKTourismDataBusMode.h"
@interface ZKTourismDataBusCell : UITableViewCell

/**
 赋值cell
 
 @param list 数据
 */
- (void)assignmentCellData:(ZKTourismDataBusMode *)list;

@end
