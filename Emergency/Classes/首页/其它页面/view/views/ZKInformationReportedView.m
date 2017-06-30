//
//  ZKInformationReportedView.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/30.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKInformationReportedView.h"

@implementation ZKInformationReportedView

/**
 获取 - ZKInformationReportedView
 
 @return ZKInformationReportedView
 */
+ (ZKInformationReportedView *)obtainReportedView;
{
    ZKInformationReportedView *view = [[NSBundle mainBundle] loadNibNamed:@"ZKInformationReportedView" owner:nil options:nil].lastObject;
    view.clipsToBounds = YES;
    return view;
}

@end
