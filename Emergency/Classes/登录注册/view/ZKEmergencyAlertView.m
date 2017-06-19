//
//  ZKEmergencyAlertView.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKEmergencyAlertView.h"

@interface ZKEmergencyAlertView ()<CAAnimationDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (nonatomic, strong) UIButton *cover;
@end

@implementation ZKEmergencyAlertView
/**
 返回button背景
 
 @return button
 */
- (UIButton *)cover
{
    if (!_cover)
    {
        _cover = [UIButton buttonWithType:UIButtonTypeCustom];
        _cover.alpha = 0.5;
        _cover.backgroundColor = [UIColor blackColor];
        [_cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cover;
}
/**
 ZKEmergencyAlertView初始化
 
 @return ZKEmergencyAlertView
 */
+ (ZKEmergencyAlertView *)emergencyAlertView;
{
    ZKEmergencyAlertView *view = [[NSBundle mainBundle] loadNibNamed:@"ZKEmergencyAlertView" owner:nil options:nil].lastObject;
    return view;
}

- (void)showsureBack:(sureBack)surePhone;
{
    if (surePhone)
    {
        self.sure = surePhone;
    }
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self.cover];
    [window addSubview:self];
    
    self.phoneTextField.delegate = self;
    [self.cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(window);
        make.width.equalTo(@275);
        make.height.equalTo(@175);
    }];
    [self.layer addAnimation:[self startAnim] forKey:@"kStartAnimAnimation"];
    
}
-(void)dismiss{
    
    [self.phoneTextField resignFirstResponder];
    [self.cover removeFromSuperview];
    [self.layer addAnimation:[self endAnim] forKey:@"kDismissAnimation"];
    
}
- (void)coverClick
{
    [self.phoneTextField resignFirstResponder];
}
//点击确定
- (IBAction)sure:(UIButton *)sender
{
    [self.phoneTextField resignFirstResponder];
    if (self.phoneTextField.text.length == 0)
    {
        hudShowError(@"请输入手机号!");
        return;
    }
    if ([ZKUtil isMobileNumber:self.phoneTextField.text])
    {
        if (self.sure)
        {
            self.sure(self.phoneTextField.text);
        }
        [self dismiss];
    }
    else
    {
        hudShowError(@"请输入正确的手机号!");
    }
}
- (IBAction)deleteButton:(UIButton *)sender
{
    [self dismiss];
}
#pragma mark  ----动画集成----
- (CAKeyframeAnimation *)startAnim
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.duration = 0.3;
    anim.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 1)],
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],];
    return anim;
}
- (CAKeyframeAnimation *)endAnim
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.delegate = self;
    anim.duration = 0.3;
    anim.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 1)],];
    return anim;
    
}
#pragma mark  ----CAAnimationDelegate----
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
{
    if (anim == [self.layer animationForKey:@"kDismissAnimation"])
    {
        [self removeFromSuperview];
    }
}
#pragma mark  ----UITextFieldDelegate----
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    //添加上拉动画
    [UIView animateWithDuration:0.3 animations:^{
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(window.mas_centerX);
            make.centerY.equalTo(window.mas_centerY).offset(-50);
        }];
        [window layoutIfNeeded];
    }];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    //添加复原动画
    [UIView animateWithDuration:0.3 animations:^{
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(window);
            
        }];
        [window layoutIfNeeded];
    }];
}
@end
