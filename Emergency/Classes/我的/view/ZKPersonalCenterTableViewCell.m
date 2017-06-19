//
//  ZKPersonalCenterTableViewCell.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKPersonalCenterTableViewCell.h"

@implementation ZKPersonalCenterTableViewCell
{

    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UIImageView *leftImageView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)selectWhichIndex:(NSInteger)index;
{
    leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"c_more0%ld",index+2]];
    nameLabel.text = index == 0?@"系统设置":@"清空缓存";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
