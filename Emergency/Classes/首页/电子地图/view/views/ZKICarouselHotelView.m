//
//  ZKICarouselHotelView.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/29.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKICarouselHotelView.h"

@interface ZKICarouselHotelView ()

@property (weak, nonatomic) IBOutlet UILabel *hotelPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotelAddresslabel;
@property (weak, nonatomic) IBOutlet UILabel *hotelLevelLabel;

@end
@implementation ZKICarouselHotelView

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
    self.hotelLevelLabel.layer.cornerRadius = 8;
    self.hotelLevelLabel.layer.borderWidth = 0.5;
    self.hotelLevelLabel.layer.borderColor = [UIColor orangeColor].CGColor;
    
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
    
//    self.nameLabel.text  = mode.name;
    self.hotelLevelLabel.text = [NSString stringWithFormat:@"  %@  ",type];
    self.hotelPhoneLabel.text = [NSString stringWithFormat:@"%@",list.phone];
    self.hotelAddresslabel.text = [NSString stringWithFormat:@"%@",list.address];
}

@end
