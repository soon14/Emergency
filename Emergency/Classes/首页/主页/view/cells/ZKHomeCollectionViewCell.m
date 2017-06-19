//
//  ZKHomeCollectionViewCell.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKHomeCollectionViewCell.h"

@implementation ZKHomeCollectionViewCell
{

    __weak IBOutlet UIImageView *contentImageView;

    __weak IBOutlet UILabel *nameLabel;
}

- (void)assignmentCell:(NSDictionary *)data;
{
    nameLabel.text = [data valueForKey:@"name"];
    contentImageView.image = [UIImage imageNamed:[data valueForKey:@"image"]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
