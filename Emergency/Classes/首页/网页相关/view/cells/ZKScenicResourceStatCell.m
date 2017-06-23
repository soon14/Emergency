//
//  ZKScenicResourceStatCell.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/23.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKScenicResourceStatCell.h"
#import "ZKScenicResourceStatMode.h"

@implementation ZKScenicResourceStatCell
{

    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *levelLabel;
    __weak IBOutlet UILabel *adderssLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    levelLabel.layer.cornerRadius = 8;
    levelLabel.layer.borderColor = CYBColorGreen.CGColor;
    levelLabel.layer.borderWidth = 0.5;
}
/**
 赋值cell
 
 @param list 数据
 */
- (void)assignmentCellData:(ZKScenicResourceStatMode *)list;
{
    nameLabel.text    = list.name;
    levelLabel.text   = [NSString stringWithFormat:@"  %@  ",list.levels];
    adderssLabel.text = list.address;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
