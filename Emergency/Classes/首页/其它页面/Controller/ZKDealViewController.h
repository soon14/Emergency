//
//  ZKDealViewController.h
//  yjPingTai
//
//  Created by 王小腊 on 2017/1/19.
//  Copyright © 2017年 WangXiaoLa. All rights reserved.
//

#import "ZKBaseViewController.h"
@class ZKInformationCollectionMode;

/**
 上报
 */
@interface ZKDealViewController : ZKBaseViewController

@property (nonatomic, strong) ZKInformationCollectionMode *mode;

@property (nonatomic, copy)void(^upTableview)();

@end
