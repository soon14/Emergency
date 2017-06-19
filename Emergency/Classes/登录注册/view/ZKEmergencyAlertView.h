//
//  ZKEmergencyAlertView.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sureBack)( NSString *telString);

@interface ZKEmergencyAlertView : UIView

@property (nonatomic, copy) sureBack sure;

/**
 ZKEmergencyAlertView初始化
 
 @return ZKEmergencyAlertView
 */
+ (ZKEmergencyAlertView *)emergencyAlertView;

/**
 显示

 @param surePhone 电话
 */
- (void)showsureBack:(sureBack)surePhone;

/**
 消失
 */
- (void)dismiss;
@end
