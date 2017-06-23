//
//  ZKTravelResourceStatCell.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/23.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKTravelResourceStatCell.h"
#import "ZKTravelResourceStatMode.h"

@implementation ZKTravelResourceStatCell
{
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *levelsLabel;
    __weak IBOutlet UILabel *contactorLabel;
    __weak IBOutlet UILabel *phoneLabel;
    __weak IBOutlet UILabel *addressLabel;
    __weak IBOutlet UILabel *amountLabel;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    levelsLabel.layer.cornerRadius = 8;
    levelsLabel.layer.borderWidth = 0.5;
    levelsLabel.layer.borderColor = [UIColor orangeColor].CGColor;
}

/**
 赋值cell
 
 @param list 数据
 */
- (void)assignmentCellData:(ZKTravelResourceStatMode *)list;
{
    nameLabel.text      = list.name;
    levelsLabel.text    = [NSString stringWithFormat:@"  %@  ",list.levels];
    contactorLabel.text = list.contactor;
    phoneLabel.text     = list.phone;
    addressLabel.text   = list.address;
    amountLabel.text    = [NSString stringWithFormat:@"%@团%@人",list.amount,list.teamtotal];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
