//
//  YYShopMainTypeView.m
//  mocha
//
//  Created by 向文品 on 14-8-4.
//  Copyright (c) 2014年 yunyao. All rights reserved.
//

#import "ZKMainTypeView.h"

#define selectFont [UIFont boldSystemFontOfSize:14]
#define normalFont [UIFont systemFontOfSize:14]

@implementation ZKMainTypeView
{
    UIView *selectView;
    NSInteger itemCount;
    
    NSArray *array;
}

-(id)initFrame:(CGRect)frame filters:(NSArray *)filters
{
    self = [super initWithFrame:frame];
    if (self) {
        array =filters;
        self.backgroundColor = [UIColor whiteColor];
        itemCount = filters.count;
        selectView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-3, self.frame.size.width/itemCount, 3)];
        selectView.backgroundColor = CYBColorGreen;
         [self addSubview:selectView];
        
        UIView *lin =[[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
        lin.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lin];
        
        for (NSInteger i=0; i<filters.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/filters.count*i, 0, frame.size.width/filters.count, frame.size.height)];
            [button setTitle:[filters objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor: CYBColorGreen forState:UIControlStateSelected];
           
            if (i == 0) {
                button.selected = YES;
                button.titleLabel.font = selectFont;
            }else{
                button.titleLabel.font = normalFont;
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-0.5, 8, 1, button.frame.size.height-16)];
                view.backgroundColor = BODER_COLOR;
                [button addSubview:view];
                
            }
            button.tag = i;
            [button addTarget:self action:@selector(selectTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
    return self;
}

-(void)select:(UIButton *)b{
    for (UIView *v in b.superview.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            [(UIButton *)v setSelected:NO];
            [(UIButton *)v titleLabel].font = normalFont;
        }
    }
    b.selected = YES;
    b.titleLabel.font = selectFont;
}

-(void)selectTypeButtonClick:(UIButton *)b{
    [self select:b];
    CGRect frame = selectView.frame;
    frame.origin.x = self.frame.size.width/itemCount*b.tag;
    [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        selectView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    if ([self.delegate respondsToSelector:@selector(selectTypeIndex:)]) {
        [self.delegate selectTypeIndex:b.tag];
    }
}

-(void)selectToIndex:(NSInteger)index{
    UIButton *button;
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIButton class]] && v.tag == index) {
            button = (UIButton *)v;
            break;
        }
    }
    [self select:button];
}

-(void)selectToValue:(NSInteger)offestX{
    CGRect frame = selectView.frame;
    frame.origin.x = offestX*self.frame.size.width/[array count];
    [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        selectView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
   
}
/**
 选中谁
 
 @param index 参数
 */
- (void)selectedCurrentItemIndex:(NSInteger)index;
{
    [self selectToIndex:index];
    [self selectToValue:index];
}
@end
