//
//  ZKBusTrajectoryTableViewCell.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/27.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKBusTrajectoryTableViewCell.h"
#import "ZKBusTrajectoryMode.h"

@implementation ZKBusTrajectoryTableViewCell
{

    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UIImageView *centenrImageView;
    __weak IBOutlet UILabel *busnumLabel;
    __weak IBOutlet UILabel *infoLabel;
    __weak IBOutlet UILabel *speedLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)cellAssignmentData:(ZKBusTrajectoryMode *)list;
{
    timeLabel.text = list.btime;
    busnumLabel.text = list.busnum;
    infoLabel.text = [NSString stringWithFormat:@"经度：%.2f : 纬度：%.2f",list.coordinate_x,list.coordinate_y];
    speedLabel.text = [NSString stringWithFormat:@"时速：%@",list.speed];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    NSString *imageName = selected?@"guijiTabelAdd":@"guijiQQ";
    UIColor *color = selected?CYBColorGreen:[UIColor blackColor];
    
    timeLabel.textColor = color;
    busnumLabel.textColor = color;
    infoLabel.textColor = color;
    speedLabel.textColor = color;
    centenrImageView.image = [UIImage imageNamed:imageName];
}

@end
