//
//  ZKInformationDealTableViewCell.h
//  yjPingTai
//
//  Created by 王小腊 on 2017/1/19.
//  Copyright © 2017年 WangXiaoLa. All rights reserved.
//

extern NSString *const ZKInformationDealTableViewCellID;

#import <UIKit/UIKit.h>
@class ZKInformationCollectionMode;

@interface ZKInformationDealTableViewCell : UITableViewCell

@property (nonatomic, strong) ZKInformationCollectionMode *mode;

@property (nonatomic, copy) void(^pushDealController)(ZKInformationCollectionMode *mode);

@end
