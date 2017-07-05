//
//  ZKInformationDealTableViewCell.m
//  yjPingTai
//
//  Created by 王小腊 on 2017/1/19.
//  Copyright © 2017年 WangXiaoLa. All rights reserved.
//

NSString *const ZKInformationDealTableViewCellID = @"ZKInformationDealTableViewCellID";

#import "ZKInformationDealTableViewCell.h"
#import "ZKInformationCollectionMode.h"

@interface ZKInformationDealTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *editorButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation ZKInformationDealTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.editorButton.layer.cornerRadius = 10;
    self.editorButton.layer.borderColor = [UIColor orangeColor].CGColor;
    self.editorButton.layer.borderWidth = 0.5;
}
- (IBAction)editorClick:(id)sender
{
    if (self.pushDealController)
    {
        self.pushDealController(_mode);
    }
}

- (void)setMode:(ZKInformationCollectionMode *)mode
{
    _mode = mode;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ 处理",mode.disposeTime];
    self.infoLabel.text = mode.disposeResult;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
