//
//  ZKBusTAnnotationView.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/27.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TAnnotationView.h"

@class ZKBusTrajectoryMode;


@interface ZKBusTAnnotationView : TAnnotationView


@property (nonatomic, strong) ZKBusTrajectoryMode *busMode;

/**
 创建气泡view
 */
- (void)createCalloutView;

/**
 更新信息
 */
- (void)updateAddress;


@end
