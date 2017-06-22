//
//  ZKResourceChooseView.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/22.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKResourceChooseView.h"
#import "TBTaskSearchView.h"

@interface ZKResourceChooseView ()
// 数据区分
@property (nonatomic) ResourceDataType resourceDataType;
// 按钮区分
@property (nonatomic) SelectedButtonType selectedButtonType;

@property (nonatomic, strong) NSMutableArray *leftArray;
@property (nonatomic, strong) NSMutableArray *rightArray;

@property (weak, nonatomic) IBOutlet TBTaskSearchView *searchView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end
@implementation ZKResourceChooseView

- (NSMutableArray *)leftArray
{
    if (!_leftArray)
    {
        _leftArray = [NSMutableArray array];
    }
    return _leftArray;
}
- (NSMutableArray *)rightArray
{
    if (!_rightArray)
    {
        _rightArray = [NSMutableArray array];
    }
    return _rightArray;
}

#pragma mark  ----视图创建----
/**
 获取 - ZKResourceChooseView
 
 @return ZKResourceChooseView
 */
+ (ZKResourceChooseView *)resourceChooseView;
{
    ZKResourceChooseView *view = [[NSBundle mainBundle] loadNibNamed:@"ZKResourceChooseView" owner:nil options:nil].lastObject;
    [view.searchView setSearchResult:^(NSString *key)
    {
        
        if ([view.delegate respondsToSelector:@selector(searchResultString:)]) {
            [view.delegate searchResultString:key];
        }
    }];

    return view;
}
/**
 配置数据
 
 @param type 搜索数据类型
 */
- (void)configurationDataSearchType:(ResourceDataType)type;
{

    
}
#pragma mark  ----按钮点击事件----
- (IBAction)lefButtonClick:(UIButton *)sender
{
    
}
- (IBAction)rightButtonClick:(UIButton *)sender
{
    
}

@end
