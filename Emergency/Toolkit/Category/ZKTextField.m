//
//  ZKTextField.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/21.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKTextField.h"

@implementation ZKTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//控制文本所在的的位置，左右缩 10
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 15 , 0 );
}

//控制编辑文本时所在的位置，左右缩 10
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 15 , 0 );
}

-(CGRect) leftViewRectForBounds:(CGRect)bounds {
    
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    
    iconRect.origin.x += 4;
    
    return iconRect;
    
}
@end
