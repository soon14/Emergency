//
//  ZKICarouselScenicView.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/29.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKICarouselScenicView.h"

@interface ZKICarouselScenicView ()

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *scenicLevelsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scenicAddressLabel;
@end
@implementation ZKICarouselScenicView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tagLabel.layer.masksToBounds = YES;
    self.tagLabel.layer.cornerRadius = 8;
}
/**
 赋值
 
 @param list 数据
 RollingViewTypeHotel  = 1,
 RollingViewTypeTravel = 2,
 RollingViewTypeScenic = 3,
 RollingViewTypeBus    = 4,
 
 */
- (void)assignmentData:(ZKElectronicMapViewMode *)list;
{
    self.scenicLevelsLabel.layer.cornerRadius = 8;
    self.scenicLevelsLabel.layer.borderColor = CYBColorGreen.CGColor;
    self.scenicLevelsLabel.layer.borderWidth = 0.5;
    
    self.tagLabel.text = [NSString stringWithFormat:@"%ld",(long)list.tag];
    self.nameLabel.text    = list.name;
    self.scenicLevelsLabel.text   = [NSString stringWithFormat:@"  %@  ",list.levels];
    self.scenicAddressLabel.text = list.address;
    NSLog(@"%@",self);
}

@end
