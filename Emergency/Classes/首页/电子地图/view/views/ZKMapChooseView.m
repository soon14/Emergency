//
//  ZKMapChooseView.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/28.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKMapChooseView.h"
#import "ZKBasicDataTool.h"
#import "ZKDataSelectBoxView.h"

@interface ZKMapChooseView ()<ZKDataSelectBoxViewDelegate>
// 数据区分
@property (nonatomic) ResourceDataType resourceDataType;
// 按钮区分
@property (nonatomic) SelectedButtonType selectedButtonType;

@property (nonatomic, strong) NSMutableArray *leftArray;
@property (nonatomic, strong) NSMutableArray *rightArray;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation ZKMapChooseView
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
 获取 - ZKMapChooseView
 
 @return ZKMapChooseView
 */
+ (ZKMapChooseView *)mapChooseView;
{
    ZKMapChooseView *view = [[NSBundle mainBundle] loadNibNamed:@"ZKMapChooseView" owner:nil options:nil].lastObject;
    view.clipsToBounds = YES;
    return view;
}
/**
 配置数据
 
 @param type 资源类型
 @param leftTitle 左name
 @param rightTitle 右name
 */
- (void)configurationDataType:(ResourceDataType)type leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle;
{
    self.resourceDataType = type;
    [self requestChooseDataType:type];
    [self setButtonTitelLeftName:leftTitle rightName:rightTitle];
    
}
#pragma mark  ----选择条件数据加载----
- (void)requestChooseDataType:(ResourceDataType)type
{
    ZKBasicDataTool *tool = [ZKBasicDataTool sharedManager];
    [self.leftArray removeAllObjects];
    [self.rightArray removeAllObjects];
    YJWeakSelf
    [tool obtainCityOne:^(NSArray *cityOne) {
        
        [weakSelf.leftArray addObject:@{@"cityname":@"不限",@"region":@""}];
        [weakSelf.leftArray addObjectsFromArray:cityOne];
    }];
    if (type == ResourceDataTypeHotel)
    {
        [tool obtainHtypeArray:^(NSArray *htypeArray) {
            
            [weakSelf.rightArray addObject:@{@"slevel":@"不限",@"type":@""}];
            [weakSelf.rightArray addObjectsFromArray:htypeArray];
        }];
    }
    else if (type == ResourceDataTypeTravel)
    {
        [tool obtainTypetravelArray:^(NSArray *typetravelArray) {
            
            [weakSelf.rightArray addObject:@{@"slevel":@"不限",@"type":@""}];
            [weakSelf.rightArray addObjectsFromArray:typetravelArray];
        }];
    }
    else if (type == ResourceDataTypeScenic)
    {
        [tool obtainLevelstrArray:^(NSArray *levelstrArray) {
            
            [weakSelf.rightArray addObject:@{@"slevel":@"不限",@"type":@""}];
            [weakSelf.rightArray addObjectsFromArray:levelstrArray];
        }];
    }
    else if (type == ResourceDataTypeGuide)
    {
        [tool obtainGuideArray:^(NSArray *guideArray) {
            
            [weakSelf.rightArray addObject:@{@"slevel":@"不限",@"type":@""}];
            [weakSelf.rightArray addObjectsFromArray:guideArray];
        }];
    }
}

#pragma mark  ----ZKDataSelectBoxViewDelegate----
/**
 弹出框选中的数据
 
 @param data 数据
 */
- (void)boxViewSelectedData:(NSDictionary *)data;
{
    if (self.selectedButtonType == SelectedButtonTypeLeft)
    {
        [self.leftButton setTitle:[data valueForKey:@"cityname"] forState:UIControlStateNormal];
    }
    else if (self.selectedButtonType == SelectedButtonTypeRight)
    {
        [self.rightButton setTitle:[data valueForKey:@"slevel"] forState:UIControlStateNormal];
    }
    
    if ([self.delegate respondsToSelector:@selector(resourceSelectedData:selectedButtonType:)]) {
        [self.delegate resourceSelectedData:data selectedButtonType:self.selectedButtonType];
    }
}

#pragma mark  ----按钮点击事件----
- (IBAction)lefButtonClick:(UIButton *)sender
{
    if (self.leftArray.count == 0)
    {
        [UIView addMJNotifierWithText:@"区域数据还在加载中" dismissAutomatically:YES];
        return;
    }
    [self showBoxViewDataType:YES];
    
}
- (IBAction)rightButtonClick:(UIButton *)sender
{
    if (self.rightArray.count == 0)
    {
        [UIView addMJNotifierWithText:@"等级数据还在加载中" dismissAutomatically:YES];
        return;
    }
    [self showBoxViewDataType:NO];
}

/**
 弹出选择框
 
 @param type 弹出类型
 */
- (void)showBoxViewDataType:(BOOL)type
{
    ZKDataSelectBoxView *boxview = [[ZKDataSelectBoxView alloc] initShowPrompt:type == YES?@"按区域选择":@"按等级选择" data:type == YES?self.leftArray:self.rightArray cellNameKey:type == YES?@"cityname":@"slevel" selectName:type == YES?self.leftButton.titleLabel.text:self.rightButton.titleLabel.text ];
    boxview.delegate = self;
    [boxview show];
    self.selectedButtonType = type == YES?SelectedButtonTypeLeft:SelectedButtonTypeRight;
}
/**
 按钮赋值
 
 @param leftName  左按钮值
 @param rightName 右按钮值
 */
- (void)setButtonTitelLeftName:(NSString *)leftName rightName:(NSString *)rightName
{
    [self.leftButton setTitle:leftName forState:UIControlStateNormal];
    [self.rightButton setTitle:rightName forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
