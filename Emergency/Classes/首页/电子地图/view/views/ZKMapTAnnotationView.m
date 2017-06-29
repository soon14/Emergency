//
//  ZKMapTAnnotationView.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/28.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKMapTAnnotationView.h"

@implementation ZKMapTAnnotationView

/**
 * 初始化动态标注视图
 * @param annotation : 动态标注
 * @param reuseIdentifier : 视图的标识
 * @return 初始化后的对象
 */
- (id)initWithAnnotation:(id <TAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
           }
    return self;
}
/**
 创建label 并赋值
 
 @param tag 值
 */
- (void)createLabelName:(NSInteger)tag;
{
    if (self.titleLabel == nil)
    {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(-3);
        }];
    }
   self.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)tag+1];
}
@end
