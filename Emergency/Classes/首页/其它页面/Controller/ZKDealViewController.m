//
//  ZKDealViewController.m
//  yjPingTai
//
//  Created by 王小腊 on 2017/1/19.
//  Copyright © 2017年 WangXiaoLa. All rights reserved.
//

#import "ZKDealViewController.h"
#import "IQTextView.h"
#import "ZKInformationCollectionMode.h"

@interface ZKDealViewController ()<UITextViewDelegate>
@property (nonatomic, strong) IQTextView *textView;
@property (nonatomic, strong) UIView *buttonbackView;
@end

@implementation ZKDealViewController
- (IQTextView *)textView
{
    if (!_textView)
    {
        _textView = [[IQTextView alloc] init];
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.placeholder = @"输入文字信息";
        _textView.font = [UIFont systemFontOfSize:13];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return _textView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"事件处理";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *linView = [[UIView alloc] init];
    linView.backgroundColor = CYBColorGreen;
    [self.view addSubview:linView];
    
    UILabel *tsLabel = [[UILabel alloc] init];
    tsLabel.font = [UIFont systemFontOfSize:14];
    tsLabel.text = @"处理内容";
    [self.view addSubview:tsLabel];
    
    UIImage *image = [UIImage imageNamed:@"infoTextView"];
    

    NSInteger leftCapWidth = image.size.width * 0.4;

    NSInteger topCapHeight = image.size.height * 0.5;
    UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];

    
    UIImageView *textBackImageView = [[UIImageView alloc] initWithImage:newImage];
    textBackImageView.userInteractionEnabled = YES;
    [self.view addSubview:textBackImageView];
    [textBackImageView addSubview:self.textView];
    
    self.buttonbackView = [[UIView alloc] init];
    self.buttonbackView.backgroundColor = [UIColor clearColor];
    self.buttonbackView.userInteractionEnabled = YES;
    [self.view addSubview:self.buttonbackView];
    
    UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [removeButton setTitle:@"清 除" forState:UIControlStateNormal];
    [removeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [removeButton addTarget:self action:@selector(removeClick) forControlEvents:UIControlEventTouchUpInside];
    removeButton.backgroundColor = CYBColorGreen;
    removeButton.layer.cornerRadius = 4;
    removeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.buttonbackView addSubview:removeButton];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"提 交" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(senderClick) forControlEvents:UIControlEventTouchUpInside];
    sendButton.backgroundColor = CYBColorGreen;
    sendButton.layer.cornerRadius = 4;
    sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.buttonbackView addSubview:sendButton];
    
    YJWeakSelf
    
    [linView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(80);
        make.left.equalTo(weakSelf.view.mas_left).offset(12);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(14);
    }];
    
    [tsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(linView.mas_centerY);
        make.left.equalTo(linView.mas_right).offset(6);
    }];
    
    [textBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(linView.mas_bottom).offset(4);
        make.right.equalTo(weakSelf.view.mas_right).offset(-12);
        make.left.equalTo(weakSelf.view.mas_left).offset(12);
        make.height.mas_equalTo(200);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(textBackImageView.mas_right).offset(-1);
        make.left.equalTo(textBackImageView.mas_left).offset(1);
        make.top.equalTo(textBackImageView.mas_top).offset(10);
        make.bottom.equalTo(textBackImageView.mas_bottom).offset(-1);
    }];
    
    [self.buttonbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textBackImageView.mas_bottom).offset(60);
        make.left.right.equalTo(textBackImageView);
        make.height.mas_equalTo(32);
    }];
    [removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.buttonbackView.mas_left).offset(16);
        make.right.equalTo(weakSelf.buttonbackView.mas_centerX).offset(-10);
        make.top.bottom.equalTo(weakSelf.buttonbackView);
        
    }];
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.buttonbackView.mas_right).offset(-16);
        make.left.equalTo(weakSelf.buttonbackView.mas_centerX).offset(10);
        make.top.bottom.equalTo(weakSelf.buttonbackView);
        
    }];
    
    if (self.mode.disposeResult.length >0)
    {
        self.textView.text = self.mode.disposeResult;
    }
}
#pragma mark  --- buttonClick---
- (void)removeClick
{
    self.textView.text = @"";
}
- (void)senderClick
{
    NSString *key = self.textView.text;
    if ([key isKindOfClass:[NSNull class]])
    {
        key = @"";
    }
    hudShowLoading(@"上报中...");
    NSMutableDictionary *dic =[ NSMutableDictionary dictionary];
    [dic setObject:key forKey:@"disposeResult"];
    [dic setObject:self.mode.ID forKey:@"id"];
    YJWeakSelf
    [ZKPostHttp post:@"" params:dic success:^(id responseObj) {
    
        NSString *message = [responseObj valueForKey:@"message"];
        NSString *state = [responseObj valueForKey:@"state"];
        
        if ([state isEqualToString:@"success"])
        {
            hudShowSuccess(message);
            if (weakSelf.upTableview)
            {
                weakSelf.upTableview();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            hudShowError(message);
        }

    } failure:^(NSError *error) {
        hudShowError(@"网络异常!");
    }];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}
#pragma mark textView
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if ((text.length+textView.text.length)>450)
    {
        [UIView addMJNotifierWithText:@"字数不能超过450字" dismissAutomatically:YES];
        return NO;
    }
    
    return YES;
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
