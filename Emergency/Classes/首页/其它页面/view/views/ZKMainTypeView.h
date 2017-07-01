//
//  DQMainTypeView.h
//  ChangYouYiBin
//
//  Created by Daqsoft-Mac on 14/11/26.
//  Copyright (c) 2014年 StrongCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MainFilterHeight 40
@protocol ZKMainTypeViewDelegate <NSObject>

/**
 选中代理

 @param index 第几个
 */
- (void)selectTypeIndex:(NSInteger)index;

@end

@interface ZKMainTypeView : UIView

@property (nonatomic,weak) id<ZKMainTypeViewDelegate >delegate;

- (id)initFrame:(CGRect)frame filters:(NSArray *)filters;
/**
 选中谁
 
 @param index 参数
 */
- (void)selectedCurrentItemIndex:(NSInteger)index;
@end
