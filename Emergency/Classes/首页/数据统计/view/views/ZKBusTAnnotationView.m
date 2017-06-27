//
//  ZKBusTAnnotationView.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/27.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKBusTAnnotationView.h"
#import "ZKBusTrajectoryMode.h"
#import "ZKCustomCalloutView.h"
#import "TAddressComponent.h"

@interface ZKBusTAnnotationView ()<TAddressComponentdelegate>

@property (nonatomic, strong) ZKCustomCalloutView *busCalloutView;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *addressLabel;
/**
 地址查询类
 */
@property (nonatomic, strong) TAddressComponent *componemt;

@end
@implementation ZKBusTAnnotationView

- (TAddressComponent *)componemt
{
    if (!_componemt)
    {
        _componemt = [[TAddressComponent alloc] init];
        _componemt.delegate = self;
    }
    return _componemt;
}
/**
 创建气泡view
 */
- (void)createCalloutView;
{
    if (self.busCalloutView == nil)
    {
        self.busCalloutView = [[ZKCustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, 160, 70)];
        self.busCalloutView.backgroundColor = [UIColor clearColor];
        [self setCalloutView:self.busCalloutView];
        
        self.timeLabel = [[UILabel  alloc] init];
        self.timeLabel.textColor = [UIColor blackColor];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        [self.busCalloutView addSubview:self.timeLabel];
        
        UIImageView *lefImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guijiMapAdd"]];
        [self.busCalloutView addSubview:lefImageView];

        self.addressLabel = [[UILabel alloc] init];
        self.addressLabel.textColor = CYBColorGreen;
        self.addressLabel.font = [UIFont systemFontOfSize:12];
        self.addressLabel.numberOfLines = 2;
        [self.busCalloutView addSubview:self.addressLabel];
        
        YJWeakSelf
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(weakSelf.busCalloutView).offset(6);
            make.right.equalTo(weakSelf.busCalloutView.mas_right).offset(-6);
        }];
        
        
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.busCalloutView.mas_right).offset(-4);
            make.height.equalTo(@34);
            make.top.equalTo(weakSelf.timeLabel.mas_bottom).offset(4);
            
        }];
        [lefImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.addressLabel.mas_centerY);
            make.left.equalTo(weakSelf.busCalloutView.mas_left).offset(6);
            make.right.equalTo(weakSelf.addressLabel.mas_left).offset(-6);
            make.width.height.equalTo(@20);
        }];
    }
}

/**
 更新信息
 */
- (void)updateAddress;
{
    self.timeLabel.text = [NSString stringWithFormat:@"%@",self.busMode.btime];
    self.addressLabel.text = @"正在查询，请稍等！";
    if (self.busMode.address.length == 0)
    {
        [self.componemt StopSearch];
        [self.componemt StartSearch:CLLocationCoordinate2DMake(self.busMode.coordinate_y, self.busMode.coordinate_x)];
    }
    else
    {
        self.addressLabel.text = self.busMode.address;
    }
}
#pragma mark  ----TAddressComponentdelegate----
/**
 * 查询结束
 * @param address : 查询的结果
 */
- (void)SearchOver:(TAddressComponent *)address;
{
    self.busMode.address = address.strPoiName;
    self.addressLabel.text = self.busMode.address;
}

/**
 * 查询出错
 * @param address : 查询的结果
 * @param error : 错误原因
 */
- (void)AddressComponent:(TAddressComponent *)address error:(NSError *)error;
{
    self.addressLabel.text = @"地址未查询到！";
}
@end
