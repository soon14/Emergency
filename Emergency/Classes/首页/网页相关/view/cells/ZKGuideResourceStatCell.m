//
//  ZKGuideResourceStatCell.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/23.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKGuideResourceStatCell.h"
#import "ZKGuideResourceStatMode.h"

@implementation ZKGuideResourceStatCell
{
    __weak IBOutlet UIImageView *photoImageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *levelsLabel;
    __weak IBOutlet UILabel *tourcardLabel;
    __weak IBOutlet UILabel *phoneLabel;
    __weak IBOutlet UILabel *travelLabel;
    __weak IBOutlet UILabel *tnameLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
/**
 赋值cell
 
 @param list 数据
 */
- (void)assignmentCellData:(ZKGuideResourceStatMode *)list;
{
    NSString *type ;
    if ([list.levels isEqualToString:@"guideLevel_1"])
    {
        type = @"初级";
    }
    else if ([list.levels isEqualToString:@"guideLevel_2"])
    {
        type = @"中级";
    }
    else if ([list.levels isEqualToString:@"guideLevel_3"])
    {
        type = @"高级";
    }
    else if ([list.levels isEqualToString:@"guideLevel_4"])
    {
        type = @"特级";
    }
    else
    {
        type = @"未知等级";
    }

    [ZKUtil downloadImage:photoImageView imageUrl:list.photo duImageName:@"cellErr"];
    nameLabel.text = list.name;
    levelsLabel.text = [NSString stringWithFormat:@"【%@】",type];
    tourcardLabel.text = list.tourcard;
    phoneLabel.text = list.phone;
    travelLabel.text = list.travel;
    tnameLabel.text = list.tname;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
