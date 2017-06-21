//
//  LDGProgressHUD.h
//  LDGProgressHUD
//
//  Created by LiDinggui on 16/3/30.
//  Copyright © 2016年 LiDinggui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LDGProgressHUDDelegate <NSObject>

- (void)showError;

@end

@interface LDGProgressHUD : UIView

@property (nonatomic,assign) id<LDGProgressHUDDelegate> delegate;

+ (void)showInView:(UIView *)view;
+ (void)dismiss;

+ (void)showInView:(UIView *)view withError:(void(^)(void))error;

@end
