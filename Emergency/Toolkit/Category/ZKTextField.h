//
//  ZKTextField.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/21.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKTextField : UITextField

- (CGRect)textRectForBounds:(CGRect)bounds;
- (CGRect)editingRectForBounds:(CGRect)bounds;

@end
