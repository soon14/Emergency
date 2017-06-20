//
//  ZKSystemSetUpViewController.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/20.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKSystemSetUpViewController.h"

@interface ZKSystemSetUpViewController ()
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIButton *onlineButton;

@end

@implementation ZKSystemSetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"系统设置";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setUI];
}
- (void)setUI
{
    [self buttonBackgroundImage:self.exitButton imageState:[ZKUtil obtainBoolForKey:ExitEmptyData]];
    [self buttonBackgroundImage:self.onlineButton imageState:[ZKUtil obtainBoolForKey:OnlineCache]];
}
#pragma mark  ----点击事件----
/**
 退出清空缓存

 @param sender UIButton
 */
- (IBAction)exitEmptyData:(UIButton *)sender
{
    BOOL state = sender.selected;
    [ZKUtil saveBoolForKey:ExitEmptyData valueBool:state];
    [self buttonBackgroundImage:sender imageState:state];
}

/**
 使用在线数据

 @param sender UIButton
 */
- (IBAction)onlineCache:(UIButton *)sender
{
    BOOL state = sender.selected;
    [ZKUtil saveBoolForKey:OnlineCache valueBool:state];
    [self buttonBackgroundImage:sender imageState:state];
}
// 按钮赋值图片
- (void)buttonBackgroundImage:(UIButton *)sender imageState:(BOOL)state
{
    NSString *imageUrl = state ?@"checked":@"check";
    sender.selected = !state;
    [sender setImage:[UIImage imageNamed:imageUrl] forState:UIControlStateNormal];
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
