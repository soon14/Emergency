//
//  ZKDataSelectBoxView.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/21.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKDataSelectBoxView.h"

@interface ZKDataSelectBoxView() <UITableViewDelegate,UITableViewDataSource>

@end

@implementation ZKDataSelectBoxView
{
    UIView   *_contentView;
    NSString *_title;
    NSArray  *_data;
    NSString *_key;
    NSString *_selectName;
    NSInteger _selectTag;
    NSDictionary *_dictionary;// 选中后的数据
    UITableView *_tableView;
}

/**
 条件选择框
 
 @param prompt 提示
 @param data 数据
 @param key cell key
 @param name 选中的字段
 @return self
 */
- (instancetype)initShowPrompt:(NSString *)prompt data:(NSArray *)data cellNameKey:(NSString *)key selectName:(NSString *)name;
{
    self =[super initWithFrame:APPDELEGATE.window.bounds];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _title      = prompt;
        _data       = data;
        _key        = key;
        _selectName = name;
        _selectTag  = -1;
        [self createViews];
        
    }
    return self;
}
- (void)createViews
{
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 4;
    [self addSubview:_contentView];
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = CYBColorGreen;
    [_contentView addSubview:topView];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = CYBColorGreen;
    [_contentView addSubview:bottomView];
    
    UILabel *titlelabel = [[UILabel alloc] init];
    titlelabel.textColor = CYBColorGreen;
    titlelabel.text = _title;
    titlelabel.font = [UIFont systemFontOfSize:20 weight:0.2];
    [_contentView addSubview:titlelabel];
    
    UIButton *disappearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [disappearButton setImage:[UIImage imageNamed:@"deleteButton"] forState:UIControlStateNormal];
    [disappearButton addTarget:self action:@selector(disappear) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:disappearButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _tableView.editing = YES;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _tableView.allowsMultipleSelectionDuringEditing = YES;
    [_contentView addSubview:_tableView];
    
    UIButton *determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [determineButton setTitle:@"确定选择" forState:UIControlStateNormal];
    [determineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [determineButton setBackgroundColor:CYBColorGreen];
    determineButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:0.2];
    [determineButton addTarget:self action:@selector(determineClick) forControlEvents:UIControlEventTouchUpInside];
    determineButton.layer.cornerRadius = 4;
    [_contentView addSubview:determineButton];
    
    YJWeakSelf
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(40);
        make.right.equalTo(weakSelf.mas_right).offset(-40);
        make.height.mas_equalTo(_SCREEN_HEIGHT/2);
        make.center.equalTo(weakSelf);
    }];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView.mas_left).offset(6);
        make.right.equalTo(_contentView.mas_right).offset(-6);
        make.height.equalTo(@1);
        make.top.equalTo(_contentView.mas_top).offset(50);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView.mas_left).offset(6);
        make.right.equalTo(_contentView.mas_right).offset(-6);
        make.height.equalTo(@1);
        make.bottom.equalTo(_contentView.mas_bottom).offset(-60);
    }];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView.mas_top);
        make.bottom.equalTo(topView.mas_top);
        make.centerX.equalTo(_contentView.mas_centerX);
    }];
    [disappearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(_contentView);
        make.bottom.equalTo(topView.mas_top);
        make.width.equalTo(@50);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_contentView);
        make.top.equalTo(topView.mas_bottom);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    [determineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView.mas_left).offset(10);
        make.right.equalTo(_contentView.mas_right).offset(-10);
        make.height.equalTo(@40);
        make.bottom.equalTo(_contentView.mas_bottom).offset(-10);
    }];
}
#pragma mark  ----UITableViewDelegate----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.tintColor = CYBColorGreen;
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.textLabel.text = [[_data objectAtIndex:indexPath.row] valueForKey:_key];
    return cell;
}
//选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectTag >= 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectTag inSection:0];
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    _dictionary = [_data objectAtIndex:indexPath.row];
    _selectTag = indexPath.row;
}
//取消选中
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectTag = -1;
    _dictionary = nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
/**
  选择设置
 */
- (void)loadTheSuccess
{
    [_data enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *name = [obj valueForKey:_key];
        if ([_selectName isEqualToString:name]) {
            
            _dictionary = obj;
            _selectTag = idx;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
    }];
}
#pragma mark  ----事件----
- (void)determineClick
{
    
}
- (void)show;
{
    self.alpha = 1;
    [self loadTheSuccess];
    [[APPDELEGATE window] addSubview:self];
    _contentView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _contentView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            [_tableView reloadData];
        }];
    }];
}
-(void)disappear
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}

@end
