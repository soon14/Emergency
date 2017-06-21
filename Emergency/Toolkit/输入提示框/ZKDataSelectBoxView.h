//
//  ZKDataSelectBoxView.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/21.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKDataSelectBoxView : UIView

/**
 条件选择框

 @param prompt 提示
 @param data 数据
 @param key cell key
 @param name 选中的字段
 @return self
 */
- (instancetype)initShowPrompt:(NSString *)prompt data:(NSArray *)data cellNameKey:(NSString *)key selectName:(NSString *)name;

/**
 弹出
 */
- (void)show;

/**
 消失
 */
- (void)disappear;

@end
