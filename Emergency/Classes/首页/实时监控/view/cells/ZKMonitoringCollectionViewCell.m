//
//  ZKMonitoringCollectionViewCell.m
//  yjPingTai
//
//  Created by 王小腊 on 2017/2/24.
//  Copyright © 2017年 WangXiaoLa. All rights reserved.
//

#import "ZKMonitoringCollectionViewCell.h"
#import "ZKTimeMonitoringMode.h"
@implementation ZKMonitoringCollectionViewCell
{
    UIButton *videoButton;
    NSString *videoUrl;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUPImageView];
        
    }
    return self;
}
- (void)setUPImageView
{
    videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    videoButton.layer.cornerRadius = 3;
    videoButton.layer.borderColor = BODER_COLOR.CGColor;
    videoButton.layer.borderWidth = 0.5;
    [videoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    videoButton.userInteractionEnabled = YES;
    videoButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [videoButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:videoButton];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = BODER_COLOR;
    [self.contentView addSubview:lineView];
    
    [videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@30);
    }];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}
- (void)updata:(ZKTimeMonitoringVideoMode *)list;
{
   [videoButton setTitle:list.name forState:UIControlStateNormal];
    videoUrl = list.url;
}
- (void)buttonClick
{
    if (self.videoButtonClick)
    {
        self.videoButtonClick(videoUrl);
    }
}
@end
