//
//  ZKTourismDataBusCell.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/24.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKTourismDataBusCell.h"


@implementation ZKTourismDataBusCell
{
    __weak IBOutlet UILabel *busnumLabel;
    __weak IBOutlet UILabel *tagView;
    __weak IBOutlet UILabel *gunameLabel;
    __weak IBOutlet UILabel *guphoneLabel;
    __weak IBOutlet UILabel *tnameLabel;
    __weak IBOutlet UILabel *adderssLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    tagView.text = @"   查看轨迹   ";
    tagView.layer.masksToBounds = YES;
    tagView.layer.cornerRadius = 8;
}
/**
 赋值cell
 
 @param list 数据
 */
- (void)assignmentCellData:(ZKTourismDataBusMode *)list;
{
    busnumLabel.text = list.busnum;
    gunameLabel.text = list.guname;
    guphoneLabel.text = list.guphone;
    tnameLabel.text  = list.tname;
    adderssLabel.text = [NSString stringWithFormat:@"经度:%.2f  纬度:%.2f",list.coordinate_x,list.coordinate_y];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
