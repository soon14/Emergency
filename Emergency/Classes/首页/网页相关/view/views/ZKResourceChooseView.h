//
//  ZKResourceChooseView.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/22.
//  Copyright © 2017年 王小腊. All rights reserved.
//

/**
 资源数据类型
 
 - ResourceStatTypeHotel: 酒店
 - ResourceStatTypeTravel: 旅行社
 - ResourceStatTypeScenic: 景区
 - ResourceStatTypeGuide: 导游
 */
typedef NS_ENUM(NSInteger,ResourceDataType) {
    
    ResourceDataTypeHotel  = 1,
    
    ResourceDataTypeTravel = 2,
    
    ResourceDataTypeScenic = 3,
    
    ResourceDataTypeGuide  = 4
    
};

/**
 按钮点击类型
 
 - SelectedButtonTypeLeft: 城市按钮
 - SelectedButtonTypeRight: 景区等级按钮
 */
typedef NS_ENUM(NSInteger,SelectedButtonType) {
    
    SelectedButtonTypeLeft = 0,
    SelectedButtonTypeRight
};

#import <UIKit/UIKit.h>

@protocol ZKResourceChooseViewDelegate <NSObject>

/**
 搜索回调

 @param key 搜索字段
 */
- (void)searchResultString:(NSString *)key;
/**
 选择数据后的回调

 @param data 数据
 @param type 是否左边按钮选择的
 */
- (void)resourceSelectedData:(NSDictionary *)data selectedButtonType:(SelectedButtonType)type;

@end
@interface ZKResourceChooseView : UIView

/**
 获取 - ZKResourceChooseView

 @return ZKResourceChooseView
 */
+ (ZKResourceChooseView *)resourceChooseView;

/**
 配置数据

 @param type 资源类型
 @param leftTitle 左name
 @param rightTitle 右name
 */
- (void)configurationDataSearchType:(ResourceDataType)type leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle;

@property (nonatomic, assign) id<ZKResourceChooseViewDelegate>delegate;

@end
