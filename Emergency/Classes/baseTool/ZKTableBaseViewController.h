//
//  ZKTableBaseViewController.h
//  Emergency
//
//  Created by 王小腊 on 2017/5/3.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKBaseViewController.h"

@interface ZKTableBaseViewController : ZKBaseViewController
// 请求后缀
@property (nonatomic, strong) NSString *postUrl;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) Class modeClass;

@property (nonatomic, strong) NSMutableDictionary *parameter;

@property (nonatomic, strong) NSMutableArray *roots;

- (void)initData NS_REQUIRES_SUPER;
- (void)setUpView NS_REQUIRES_SUPER;
- (void)endDataRequest;//数据请求结束
- (void)updataTableView;

@end
