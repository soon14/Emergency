//
//  TBTaskSearchView.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/5.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBTaskSearchView.h"

@interface TBTaskSearchView ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@end
@implementation TBTaskSearchView
- (instancetype)init
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self createView];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self createView];

}
- (void)createView
{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 5;
    [self addSubview:backView];
    
    UIView *linView = [[UIView alloc] init];
    linView.backgroundColor = BODER_COLOR;
    [backView addSubview:linView];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入关键字搜索";
    _searchBar.userInteractionEnabled = YES;
    _searchBar.barTintColor = [UIColor whiteColor];
    [_searchBar setBackgroundImage:[UIImage new]];
    _searchBar.returnKeyType = UIReturnKeySearch;
    [backView addSubview:_searchBar];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
    }];
    
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(backView);
    }];

}
/**
 清空
 */
- (void)empty;
{
    self.searchBar.text = @"";
}
// 赋值搜索字段
- (void)assignmentText:(NSString *)text;
{
    self.searchBar.text = text;
}
#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    if (self.searchTextDidChange)
    {
        self.searchTextDidChange(searchBar.text);
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    [self endEditing:YES];
    NSString *key = searchBar.text;
    if (self.searchResult)
    {
        self.searchResult(key);
    }
}
//让 UISearchBar 支持空搜索，当没有输入的时候，search 按钮一样可以点击
- (void)searchBarTextDidBeginEditing:(UISearchBar *) searchBar
{
    UITextField *searchBarTextField = nil;
    NSArray *views = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) ? searchBar.subviews : [[searchBar.subviews objectAtIndex:0] subviews];
    for (UIView *subview in views)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchBarTextField = (UITextField *)subview;
            break;
        }
    }
    searchBarTextField.enablesReturnKeyAutomatically = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;
{
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
@end
