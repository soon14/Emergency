//
//  UIView+ExclusiveTouch.h
//  ExclusiveTouchDemo
//
//  Created by wangyongkang on 17/6/19.
//  Copyright © 2017年 王永康. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>

@interface UIView (ExclusiveTouch)<UIAppearance, UIAppearanceContainer>

@property(nonatomic, assign) BOOL ygExclusiveTouch UI_APPEARANCE_SELECTOR; // default is NO

@end
