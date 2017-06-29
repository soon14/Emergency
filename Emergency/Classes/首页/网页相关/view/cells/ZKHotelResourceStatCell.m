//
//  ZKHotelResourceStatCell.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/23.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKHotelResourceStatCell.h"
#import "ZKHotelResourceStatMode.h"

@implementation ZKHotelResourceStatCell
{
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *levelLabel;
    __weak IBOutlet UILabel *phoneLabel;
    __weak IBOutlet UILabel *adderssLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    levelLabel.layer.cornerRadius = 8;
    levelLabel.layer.borderWidth = 0.5;
    levelLabel.layer.borderColor = [UIColor orangeColor].CGColor;
}
/**
 赋值cell
 
 @param list 数据
 */
- (void)assignmentCellData:(ZKHotelResourceStatMode *)list;
{
    NSString *type;
    if ([list.levels isEqualToString:@"hotelStarLevel_1"])
    {
        type = @"一星级酒店";
    }
    else if ([list.levels isEqualToString:@"hotelStarLevel_2"])
    {
        type = @"二星级酒店";
    }
    else if ([list.levels isEqualToString:@"hotelStarLevel_3"])
    {
        type = @"三星级酒店";
    }
    else if ([list.levels isEqualToString:@"hotelStarLevel_4"])
    {
        type = @"四星级酒店";
    }
    else if ([list.levels isEqualToString:@"hotelStarLevel_5"])
    {
        type = @"五星级酒店";
    }
    else
    {
        type = @"未知级酒店";
    }
    
    nameLabel.text  = list.name;
    levelLabel.text = [NSString stringWithFormat:@" %@ ",type];
    phoneLabel.text = [NSString stringWithFormat:@"联系电话：%@",list.phone];
    adderssLabel.text = [NSString stringWithFormat:@"联系地址：%@",list.address];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
