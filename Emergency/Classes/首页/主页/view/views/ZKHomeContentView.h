//
//  ZKHomeContentView.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZKHomeContentViewDelegate <NSObject>
@optional

/**
 cell点击

 @param dictionary 字典
 */
- (void)homeContentCellClickData:(NSDictionary *)dictionary;

@end
/**
 加载的九宫格内容视图
 */
@interface ZKHomeContentView : UIView

@property (nonatomic, assign) id<ZKHomeContentViewDelegate>delegate;


@end
