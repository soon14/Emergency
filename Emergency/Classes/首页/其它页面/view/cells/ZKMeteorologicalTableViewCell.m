//
//  ZKMeteorologicalTableViewCell.m
//  Emergency
//
//  Created by 王小腊 on 2017/7/5.
//  Copyright © 2017年 王小腊. All rights reserved.
//

NSString *const ZKMeteorologicalTableViewCellID = @"ZKMeteorologicalTableViewCellID";

#import "ZKMeteorologicalTableViewCell.h"
#import "ZKMeteorologicalESRootClass.h"
@implementation ZKMeteorologicalTableViewCell
{
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UILabel *weatherLabel;
    __weak IBOutlet UILabel *temperatureLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
/**
 cell赋值
 
 @param root 数据
 @param date 日期
 @param state 白天还是黑夜
 @param index 第几个
 */
- (void)assignmentData:(ZKMeteorologicalWeather *)root date:(NSString *)date dayState:(BOOL)state cellIndex:(NSInteger)index;
{
    UIColor *color =index == 0 ? CYBColorGreen:[UIColor blackColor];
    dateLabel.textColor = weatherLabel.textColor = temperatureLabel.textColor = color;
    dateLabel.text = date;
    weatherLabel.text = state?root.txt_d:root.txt_n;
    temperatureLabel.text = [NSString stringWithFormat:@"%@°C-%@°C",root.max,root.min];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
