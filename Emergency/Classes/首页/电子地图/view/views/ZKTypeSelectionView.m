//
//  ZKTypeSelectionView.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/28.
//  Copyright © 2017年 王小腊. All rights reserved.
//

static NSString *normalStr = @"check";
static NSString *highlightedStr = @"checked";

#import "ZKTypeSelectionView.h"

@interface ZKTypeSelectionView ()

@property (nonatomic, strong) NSMutableArray <UIImageView*>*imageArray;
@property (nonatomic, strong) NSArray *typeArray;
// 记录选择的类型
@property (nonatomic, assign) NSInteger index;

@end
@implementation ZKTypeSelectionView
- (NSMutableArray<UIImageView *> *)imageArray
{
    
    if (!_imageArray) {
        
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
    
}
- (instancetype)initWithFrame:(CGRect)frame;
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIView *bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
        bannerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:bannerView];
        
        NSArray *titis = @[@"景点",@"酒店",@"旅行社",@"旅游大巴"];
        self.typeArray = @[@"3",@"1",@"2",@"4"];
        float gapWidth = self.frame.size.width/titis.count-2;
        
        for (int i=0; i<titis.count; i++) {
            
            UIImageView* lefView = [[UIImageView alloc]initWithFrame:CGRectMake(8+gapWidth*i,(40-16)/2, 16, 16)];
            lefView.backgroundColor =[UIColor clearColor];
            lefView.tag = i+1000;
            lefView.image = [UIImage imageNamed:normalStr];
            [self addSubview:lefView];
            [self.imageArray addObject:lefView];
            
            UILabel *  name = [[UILabel alloc]initWithFrame:CGRectMake(gapWidth*i+ 28, 0, gapWidth, 40)];
            name.backgroundColor = [UIColor clearColor];
            name.textColor = [UIColor whiteColor];
            name.textAlignment = NSTextAlignmentLeft;
            name.font = [UIFont systemFontOfSize:13];
            name.text = titis[i];
            [self addSubview:name];
            
            UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(gapWidth*i, 0, gapWidth, 40)];
            button.backgroundColor = [UIColor clearColor];
            button.tag = i+3000;
            [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:button];
        }

    }
    
    return self;
}
#pragma mark button点击事件
- (void)selectButton:(UIButton*)sender
{
    NSInteger row = sender.tag - 3000;
    // 点击同一个不予理会
    if (self.index != row)
    {
        SelectionDataType type = [self.typeArray[row] integerValue];
        [self selectType:row];
        if ([self.delegate respondsToSelector:@selector(selectedResultsType:)]) {
            [self.delegate selectedResultsType:type];
        }
    }
}

/**
 *  选中状态
 *
 *  @param pag 选中哪个
 */
- (void)selectType:(NSInteger)pag
{
    self.index = pag;
    [self endEditing:YES];
    [self.imageArray enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.image = pag == idx  ? [UIImage imageNamed:highlightedStr]:[UIImage imageNamed:normalStr];
    } ];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
