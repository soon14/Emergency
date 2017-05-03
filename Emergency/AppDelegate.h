//
//  AppDelegate.h
//  Emergency
//
//  Created by 王小腊 on 2017/4/28.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (retain, nonatomic) MainTabBarController *tabBarController;
/**
 创建主题
 */
- (void)createTabBarController;

@end

