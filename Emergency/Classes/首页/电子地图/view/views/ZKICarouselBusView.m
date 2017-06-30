//
//  ZKICarouselBusView.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/29.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKICarouselBusView.h"

@interface ZKICarouselBusView ()

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *busGunameLabel;
@property (weak, nonatomic) IBOutlet UILabel *busGuphoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *busTnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *busAdderssLabel;

@end
@implementation ZKICarouselBusView
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
    self.tagLabel.text = [NSString stringWithFormat:@"%ld",(long)list.tag];
    self.nameLabel.text = list.busnum;
    self.busGunameLabel.text = list.guname;
    self.busGuphoneLabel.text = list.guphone;
    self.busTnameLabel.text  = list.tname;
    self.busAdderssLabel.text = [NSString stringWithFormat:@"经度:%.2f  纬度:%.2f",list.coordinate_x,list.coordinate_y];
}

@end
