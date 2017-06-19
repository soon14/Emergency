//
//  ZKRegisteredViewController.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/6.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKRegisteredViewController.h"
#import "ZKEmergencyAlertView.h"
#import "AppDelegate.h"
#import <SAMKeychain/SAMKeychain.h>
@interface ZKRegisteredViewController ()

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UIImageView *centerImageView;
// 提示文本信息
@property (nonatomic, strong) UILabel     *tooltipTextLabel;
// 登录按钮
@property (nonatomic, strong) UIButton    *loginButton;

@property (nonatomic, strong) ZKEmergencyAlertView *phoneAlertView;

@end

@implementation ZKRegisteredViewController

#pragma mark  ----懒加载----
- (ZKEmergencyAlertView *)phoneAlertView
{
    if (!_phoneAlertView)
    {
        _phoneAlertView = [ZKEmergencyAlertView emergencyAlertView];
    }
    return _phoneAlertView;
}
- (UILabel *)tooltipTextLabel
{
    if (!_tooltipTextLabel) {
        _tooltipTextLabel = [[UILabel alloc] init];
        _tooltipTextLabel.textColor = [UIColor whiteColor];
        _tooltipTextLabel.font = [UIFont systemFontOfSize:18];
        _tooltipTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tooltipTextLabel;
}
- (UIButton *)loginButton
{
    if (!_loginButton)
    {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"手机号验证" forState:UIControlStateNormal];
        [_loginButton setTitleColor:CYBColorGreen forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.layer.masksToBounds = YES;
        _loginButton.layer.cornerRadius  = 4;
        _loginButton.layer.borderColor   = BODER_COLOR.CGColor;
        _loginButton.layer.borderWidth   = 0.5;
        _loginButton.backgroundColor     = [UIColor whiteColor];
        _loginButton.hidden = YES;
    }
    return _loginButton;
}
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

- (NSString *)randomUUID
{
    NSString * currentDeviceUUIDStr = [SAMKeychain passwordForService:@" "account:@"uuid"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SAMKeychain setPassword: currentDeviceUUIDStr forService:@" "account:@"uuid"];
    }
    return currentDeviceUUIDStr;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createViews];
    [self macValidation];
}
#pragma mark  ----数据请求----

/**
 mac地址验证
 */
- (void)macValidation
{
    NSString * identifier =  [self randomUUID];
    NSString *url = [NSString stringWithFormat:@"%@appUser/loginToMAC?format=json&mac=%@",POST_URL,identifier];
    self.tooltipTextLabel.text = @"";
    self.loginButton.hidden = YES;
    hudShowLoading(@"正在验证手机地址...");
    YJWeakSelf
    [ZKPostHttp getddByUrlPath:url andParams:nil andCallBack:^(id responseObj) {
        [weakSelf macValidationResultData:responseObj];
    }];
    
}
/**
 用户注册
 
 @param phone 电话号码
 */
- (void)phoneValidation:(NSString *)phone
{
    // 判断是不是演示手机号
    if ([phone isEqualToString:USER_PASSWORD]) {
        
        [self initController];
        return ;
    }
    NSString * identifier = [self randomUUID];
    NSString *url = [NSString stringWithFormat:@"%@appUser/registerToPhone?format=json&mac=%@&phone=%@",POST_URL,identifier,phone];
    hudShowLoading(@"正在注册...");
    YJWeakSelf
    [ZKPostHttp getddByUrlPath:url andParams:nil andCallBack:^(id responseObj) {
        [weakSelf phoneValidationResultData:responseObj];
    }];
}
#pragma mark  ----一些逻辑----
- (void)phoneValidationResultData:(NSDictionary *)responseObj
{
    NSString *state = [responseObj valueForKey:@"state"];
    if ([state isEqualToString:@"success"])
    {
        NSDictionary *data = [responseObj valueForKey:@"data"];
        NSString * message = [data valueForKey:@"hint"];
        if ([message isEqualToString:@"更新成功"])
        {
            hudDismiss();
            [self initController];
        }
        else
        {
            hudShowSuccess(message);
            self.tooltipTextLabel.text = @"注册成功，请等待审核！";
            self.loginButton.hidden = YES;
        }
    }
    else
    {
        [self postErrorMessage:@"数据异常，请稍后再试！"];
    }
}
- (void)macValidationResultData:(NSDictionary *)responseObj
{
    NSString *state = [responseObj valueForKey:@"state"];
    if ([state isEqualToString:@"success"])
    {
        [ZKUtil saveBoolForKey:IS_ADMIN valueBool:[[responseObj valueForKey:@"isAdmin"] boolValue]];
        NSInteger state = [[responseObj valueForKey:@"data"] integerValue];
        // 1.已启用  2.未审核  99.不存在  0.未启用
        hudDismiss();
        switch (state)
        {
            case 0:
                self.tooltipTextLabel.text = @"账号尚未启动，请耐心等待！";
                self.loginButton.hidden = NO;
                break;
            case 1:
                [self initController];
                break;
            case 2:
                self.tooltipTextLabel.text = @"账号尚未审核，请耐心等待！";
                self.loginButton.hidden = NO;
                break;
            case 99:
                [self showPhoneView];
                break;
                
            default:
                break;
        }
    }
    else
    {
        [self postErrorMessage:@"数据异常，请稍后再试！"];
    }
}

// 错误提示
- (void)postErrorMessage:(NSString *)message
{
    self.tooltipTextLabel.text = message;
    hudShowError(message);
    self.loginButton.hidden = NO;
}
// 弹出电话输入框
- (void)showPhoneView
{
    self.loginButton.hidden = NO;
    YJWeakSelf
    [self.phoneAlertView showsureBack:^(NSString *telString) {
        
        [weakSelf phoneValidation:telString];
    }];
}

/**
 进入主界面
 */
- (void)initController
{
    [ZKUtil saveBoolForKey:LoginState valueBool:YES];
    
    [(AppDelegate *)[UIApplication sharedApplication].delegate createTabBarController];
}
#pragma mark  ----视图创建----
- (void)createViews
{
    CGFloat centerImageSize = _SCREEN_WIDTH/3;
    
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.centerImageView];
    [self.view addSubview:self.tooltipTextLabel];
    [self.view addSubview:self.loginButton];
    
    self.tooltipTextLabel.text = @"登录中...";
    
    YJWeakSelf  // 布局
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.mas_equalTo(centerImageSize);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(weakSelf.view.mas_centerY).offset(-centerImageSize);
    }];
    
    [self.tooltipTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.centerImageView.mas_bottom).offset(24);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-80);
        make.height.equalTo(@36);
        make.width.equalTo(@100);
    }];
    
    
}
#pragma mark  ----按钮点击事件----
- (void)loginClick
{
    [self showPhoneView];
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
