//
//  ZKTypeSelectionView.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/28.
//  Copyright © 2017年 王小腊. All rights reserved.
//

/**
 选择类型
 
 - SelectionDataTypeHotel: 酒店
 - SelectionDataTypeTravel: 旅行社
 - SelectionDataTypeScenic: 景区
 - SelectionDataTypeBus: 大巴
 */
typedef NS_ENUM(NSInteger, SelectionDataType) {
    
    SelectionDataTypeHotel  = 1,
    SelectionDataTypeTravel = 2,
    SelectionDataTypeScenic = 3,
    SelectionDataTypeBus  = 4,
};

#import <UIKit/UIKit.h>

@protocol ZKTypeSelectionViewDelegate <NSObject>

/**
 选中结果类型

 @param type 类型
 */
-  (void)selectedResultsType:(SelectionDataType)type;

@end
@interface ZKTypeSelectionView : UIView

/**
 *  初始化地图单选
 *
 *  @param frame Fram
 *
 *  @return view
 */
- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, assign) id<ZKTypeSelectionViewDelegate> delegate;

/**
 默认选中哪一个
 
 @param pag 第几个
 */
- (void)selectType:(NSInteger)pag;
@end
