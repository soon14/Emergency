//
//  ZKICarouselTravelView.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/29.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKICarouselTravelView.h"

@interface ZKICarouselTravelView ()
@property (weak, nonatomic) IBOutlet UILabel *travelLevelsLabel;
@property (weak, nonatomic) IBOutlet UILabel *travelContactorLabel;
@property (weak, nonatomic) IBOutlet UILabel *travelPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *travelAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *travelAmountLabel;

@end
@implementation ZKICarouselTravelView

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
    self.travelLevelsLabel.layer.cornerRadius = 8;
    self.travelLevelsLabel.layer.borderWidth = 0.5;
    self.travelLevelsLabel.layer.borderColor = [UIColor orangeColor].CGColor;
    
//    self.nameLabel.text      = list.name;
    self.travelLevelsLabel.text    = [NSString stringWithFormat:@"  %@  ",list.levels];
    self.travelContactorLabel.text = list.contactor;
    self.travelPhoneLabel.text     = list.phone;
    self.travelAddressLabel.text   = list.address;
    self.travelAmountLabel.text    = [NSString stringWithFormat:@"%@团%@人",list.amount,list.teamtotal];
}

@end
