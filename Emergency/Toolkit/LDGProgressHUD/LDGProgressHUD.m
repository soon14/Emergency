//
//  LDGProgressHUD.m
//  LDGProgressHUD
//
//  Created by LiDinggui on 16/3/30.
//  Copyright © 2016年 LiDinggui. All rights reserved.
//

#import "LDGProgressHUD.h"

@interface LDGProgressHUD()

@property (nonatomic,strong,readonly) UIImageView *imageView;

+ (LDGProgressHUD *)sharedView;

- (void)showInView:(UIView *)view;
- (void)dismiss;

- (void)showInView:(UIView *)view withError:(void(^)(void))error;

@end

//355 × 286 pixels
#define imageViewWidth (355.0 / 3.0)
#define imageViewHeight (286.0 / 3.0)
#define frameRate (0.2)

@implementation LDGProgressHUD

@synthesize imageView;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (LDGProgressHUD *)sharedView
{
    static LDGProgressHUD *sharedView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedView = [[LDGProgressHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return sharedView;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }
    return self;
}

- (UIImageView *)imageView
{
    if (imageView == nil)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageViewWidth, imageViewHeight)];
        imageView.center = CGPointMake(self.bounds.size.height / 2.0, self.bounds.size.width / 2.0);
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        
        NSMutableArray *images = [NSMutableArray new];
        for (NSInteger i = 1; i <= 4; i++)
        {
            NSString *imageName = [NSString stringWithFormat:@"LDGProgressHUD.bundle/H-0%ld.jpg",(long)i];
            UIImage *image = [UIImage imageNamed:imageName];
            [images addObject:image];
        }
        
        imageView.animationImages = [NSArray arrayWithArray:images];
        imageView.animationDuration = images.count * frameRate;
        imageView.animationRepeatCount = 0;

    }
    
    if (!imageView.superview)
    {
        [self addSubview:imageView];
     
        
    }
    
    return imageView;
}

- (void)showInView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.superview)
        {
            [view addSubview:self];
        }
        
        if (![self.imageView isAnimating])
        {
            [self.imageView startAnimating];
        }
        
        if (self.alpha != 1)
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }
    });
}

- (void)dismiss
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self.imageView stopAnimating];
            [self removeFromSuperview];
        }];
    });
}

- (void)showInView:(UIView *)view withError:(void(^)(void))error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.superview)
        {
            [view addSubview:self];

        }
        
        if (![self.imageView isAnimating])
        {
            [self.imageView startAnimating];
        }
        
        if (self.alpha != 1)
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }

        [self performSelector:@selector(error:) withObject:error afterDelay:20];
    
        
    });
}

- (void)error:(void(^)(void))error
{
    [self dismiss];
    
    error();
}

+ (void)showInView:(UIView *)view
{
    [[LDGProgressHUD sharedView] showInView:view];
}

+ (void)dismiss
{
    [[LDGProgressHUD sharedView] dismiss];
}

+ (void)showInView:(UIView *)view withError:(void(^)(void))error
{
    [[LDGProgressHUD sharedView] showInView:view withError:error];
}

@end
