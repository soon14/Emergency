//
//  ZKICarouselScenicView.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/29.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKICarouselScenicView.h"

@interface ZKICarouselScenicView ()

@property (weak, nonatomic) IBOutlet UILabel *scenicLevelsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scenicAddressLabel;
@end
@implementation ZKICarouselScenicView
/**
 赋值
 
 @param list 数据
 RollingViewTypeHotel  = 1,
 RollingViewTypeTravel = 2,
 RollingViewTypeScenic = 3,
 RollingViewTypeBus    = 4,
 
 @param show 是否显示列表按钮
 */
- (void)assignmentData:(ZKElectronicMapViewMode *)list  showListButton:(BOOL)show;
{
    self.scenicLevelsLabel.layer.cornerRadius = 8;
    self.scenicLevelsLabel.layer.borderColor = CYBColorGreen.CGColor;
    self.scenicLevelsLabel.layer.borderWidth = 0.5;
    
//    self.nameLabel.text    = list.name;
    self.scenicLevelsLabel.text   = [NSString stringWithFormat:@"  %@  ",list.levels];
    self.scenicAddressLabel.text = list.address;
    NSLog(@"%@",self);
}

@end
