//
//  ZKTourismDataTeamCell.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/24.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKTourismDataTeamCell.h"

@implementation ZKTourismDataTeamCell
{
    __weak IBOutlet UILabel *tnameLabel;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *amountLabel;
    __weak IBOutlet UILabel *timeLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/**
 赋值cell
 
 @param list 数据
 */
- (void)assignmentCellData:(ZKTourismDataTeamMode *)list;
{
    tnameLabel.text = list.tname;
    nameLabel.text  = list.name;
    amountLabel.text = [NSString stringWithFormat:@"%@人",list.amount];
    timeLabel.text  = [NSString stringWithFormat:@"%@-%@",[list.arrivetime stringByReplacingOccurrencesOfString:@"-" withString:@"."],[list.leavetime stringByReplacingOccurrencesOfString:@"-" withString:@"."]];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
