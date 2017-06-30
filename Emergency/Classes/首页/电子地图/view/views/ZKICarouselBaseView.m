//
//  ZKICarouselBaseView.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/29.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKICarouselBaseView.h"
#import "UIButton+ImageTitleStyle.h"
@implementation ZKICarouselBaseView
/**
 获取view
 
 @param name 类名
 @param show 是否显示列表按钮
 @return self
 */
+ (id)accessViewClassName:(NSString *)name showListButton:(BOOL)show;
{
    ZKICarouselBaseView *view = [[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil].lastObject;
    
    if (show) {
        
        UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [listButton setTitle:@"列表模式" forState:UIControlStateNormal];
        [listButton setImage:[UIImage imageNamed:@"map_liebiao"] forState:UIControlStateNormal];
        [listButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        listButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [listButton addTarget:view action:@selector(listViewClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:listButton];
        
        [listButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view.mas_right).offset(0);
            make.top.equalTo(view.mas_top).offset(15);
        }];
       [listButton setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:2];
    }
    return view;
}
/**
 赋值
 
 @param list 数据
 RollingViewTypeHotel  = 1,
 RollingViewTypeTravel = 2,
 RollingViewTypeScenic = 3,
 RollingViewTypeBus    = 4,
 
 */
- (void)assignmentData:(ZKElectronicMapViewMode *)list;
{

}
- (void)listViewClick
{
    if ([self.delegate respondsToSelector:@selector(jumpToListViewControllerData:)]) {
        [self.delegate jumpToListViewControllerData:self.mapList];
    }
    
}
@end
