//
//  ZKMapTAnnotationView.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/28.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TAnnotationView.h"

@interface ZKMapTAnnotationView : TAnnotationView

@property (nonatomic, strong) UILabel *titleLabel;

/**
 创建label 并赋值

 @param tag 值
 */
- (void)createLabelName:(NSInteger)tag;
@end
