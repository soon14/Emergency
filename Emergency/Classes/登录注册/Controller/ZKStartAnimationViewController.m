//
//  ZKStartAnimationViewController.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/6.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKStartAnimationViewController.h"
#import "AppDelegate.h"

@interface ZKStartAnimationViewController ()

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UIImageView *centerImageView;

@property (nonatomic, strong) UILabel     *nameLabel;

@property (nonatomic, strong) UILabel     *infoLabel;

@property (nonatomic, strong) UIView      *lefLin;

@property (nonatomic, strong) UIView      *rightLin;

@property (nonatomic, assign) CGFloat     centerImageSize;
@end

@implementation ZKStartAnimationViewController
@synthesize centerImageSize;

#pragma mark  ----懒加载----
- (UIImageView *)backImageView
{
    if (!_backImageView)
    {
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default"]];
    }
    return _backImageView;
}
- (UIImageView *)centerImageView
{
    if (!_centerImageView)
    {
        _centerImageView             = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noData"]];
        _centerImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _centerImageView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel               = [[UILabel alloc] init];
        _nameLabel.font          = [UIFont systemFontOfSize:22 weight:0.4];
        _nameLabel.textColor     = [UIColor whiteColor];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel)
    {
        _infoLabel               = [[UILabel alloc] init];
        _infoLabel.font          = [UIFont systemFontOfSize:16 weight:0.1];
        _infoLabel.textColor     = RGB(143, 214, 170);
        _infoLabel.numberOfLines = 1;
        _infoLabel.layer.opacity = 0.0;
        _infoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _infoLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
    [self startAnimation];
}
#pragma mark  ----视图创建----
- (void)createViews
{
    
    centerImageSize = _SCREEN_WIDTH/3;
    
    NSString *name      = [NSString stringWithFormat:@"%@",AnimationView_name];
    NSString *info      = [NSString stringWithFormat:@"%@",AnimationView_info];
    
    self.nameLabel.text = name;
    self.infoLabel.text = info;
    
    self.lefLin                   = [[UIView alloc] init];
    self.lefLin.backgroundColor   = RGB(143, 214, 170);
    self.lefLin.layer.opacity     = 0.0;
    
    self.rightLin                 = [[UIView alloc] init];
    self.rightLin.backgroundColor = RGB(143, 214, 170);
    self.rightLin.layer.opacity   = 0.0;
    
    
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.centerImageView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.infoLabel];
    [self.view addSubview:self.lefLin];
    [self.view addSubview:self.rightLin];
    
    // 改变行间距
    [ZKUtil changeLineSpaceForLabel:self.nameLabel WithSpace:8];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    YJWeakSelf  // 布局
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.mas_equalTo((centerImageSize/2));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(weakSelf.view.mas_centerY).offset(-centerImageSize);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.centerImageView.mas_bottom).offset(30);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.height.equalTo(@30);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(30);
    }];
    
    [self.lefLin mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.infoLabel.mas_centerY);
        make.left.equalTo(weakSelf.view.mas_left).offset(12);
        make.right.equalTo(weakSelf.infoLabel.mas_left).offset(-12);
        make.height.equalTo(@1);
    }];
    
    [self.rightLin mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(weakSelf.infoLabel.mas_centerY);
        make.right.equalTo(weakSelf.view.mas_right).offset(-12);
        make.left.equalTo(weakSelf.infoLabel.mas_right).offset(12);
        make.height.equalTo(@1);
    }];
}
#pragma mark  ----开始动画----
- (void)startAnimation
{
    //如果其约束还没有生成的时候需要动画的话，就请先强制刷新后才写动画，否则所有没生成的约束会直接跑动画
    [self.view.superview layoutIfNeeded];
    [self labelAnimate];
    YJWeakSelf
    [UIView animateWithDuration:1.0 animations:^{
        
        [self.centerImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.height.mas_equalTo(centerImageSize);
            make.centerX.equalTo(weakSelf.view.mas_centerX);
            make.centerY.equalTo(weakSelf.view.mas_centerY).offset(-centerImageSize);
        }];
        
        // mas动画必须加入此方法  layoutIfNeeded
        [self.centerImageView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1 animations:^{
            
            weakSelf.lefLin.layer.opacity     = 1.0;
            weakSelf.rightLin.layer.opacity   = 1.0;
            weakSelf.infoLabel.layer.opacity  = 1.0;
        } completion:^(BOOL finished) {
            [weakSelf animateEnd];
        }];
    }];
}

/**
 动画结束后
 */
- (void)animateEnd
{
    // 是否登录
    BOOL loginState = [ZKUtil obtainBoolForKey:LoginState];
    if (loginState == YES)
    {
        [(AppDelegate *)APPDELEGATE createTabBarController];
    }
    else
    {
        [[(AppDelegate *)APPDELEGATE window] setRootViewController:[NSClassFromString(@"ZKRegisteredViewController") new]];
    }
}
/**
 字体动画
 */
- (void)labelAnimate
{
    [UIView animateWithDuration:1 animations:^{
        
        CABasicAnimation *aniScale   = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        aniScale.fromValue           = [NSNumber numberWithFloat:0.5];//开始大小
        aniScale.toValue             = [NSNumber numberWithFloat:1.0];//放大到多大后结束
        aniScale.duration            = 1;
        aniScale.removedOnCompletion = NO;
        aniScale.repeatCount         = 1;
        [self.nameLabel.layer addAnimation:aniScale forKey:@"babyCoin_scale"];
        
    } completion:^(BOOL finished) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
