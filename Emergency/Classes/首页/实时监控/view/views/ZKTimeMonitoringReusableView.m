//
//  ZKTimeMonitoringReusableView.m
//  yjPingTai
//
//  Created by 王小腊 on 2017/2/24.
//  Copyright © 2017年 WangXiaoLa. All rights reserved.
//

#import "ZKTimeMonitoringReusableView.h"
@implementation ZKTimeMonitoringReusableView
{
    UILabel *contenLabel;
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
    UIView *linView = [[UIView alloc] init];
    linView.backgroundColor = CYBColorGreen;
    [self addSubview:linView];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = BODER_COLOR;
    [self addSubview:bottomView];
    
    contenLabel = [[UILabel alloc] init];
    contenLabel.font = [UIFont systemFontOfSize:14];
    contenLabel.textColor = CYBColorGreen;
    [self addSubview:contenLabel];
    
    [linView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@8);
        make.width.equalTo(@4);
        make.height.equalTo(@16);
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
    [contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(linView.mas_right).equalTo(@8);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}
- (void)updataTitle:(NSString *)title;
{
    contenLabel.text = title;
}
@end
