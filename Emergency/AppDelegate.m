//
//  AppDelegate.m
//  Emergency
//
//  Created by 王小腊 on 2017/4/28.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "AppDelegate.h"
#import "TBUpdateTooltipView.h"
#import "ZKPersonalCenterViewController.h"
#import "ZKHomeViewController.h"
#import "ZKNavigationController.h"
#import "ZKStartAnimationViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "UIImageView+WebCache.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setUpLib];
    [self checkVersion];
    // 开启动画页面
    ZKStartAnimationViewController *animationViewController = [[ZKStartAnimationViewController alloc] init];
    self.window.rootViewController = animationViewController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

/**
 创建主题
 */
- (void)createTabBarController;
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    //init tab
    
    self.tabBarController = [[MainTabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.tabBarController.tabBar.contentMode = UIViewContentModeScaleAspectFill;
    NSMutableArray *controllers = [NSMutableArray array];
    
    
    ZKHomeViewController *homeController = [[ZKHomeViewController alloc] init];
    UIViewController *centerController = [UIViewController new];
    ZKPersonalCenterViewController *personalController = [[ZKPersonalCenterViewController alloc] init];
    
    homeController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"hom_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"hom_0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    homeController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    ZKNavigationController*homeNav = [[ZKNavigationController alloc]initWithRootViewController:homeController];
    [controllers addObject:homeNav];
    
    NSString *centerIcon = @"AboutUs";
#if LeShan
    centerIcon = @"duty_Packup";
    
#endif
    ZKNavigationController *recommendNav=[[ZKNavigationController alloc]initWithRootViewController:centerController];
    centerController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:centerIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:centerIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [recommendNav setNavigationBarHidden:YES animated:NO];
    [controllers addObject:recommendNav];
    
    
    personalController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"mine_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"mine_0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    personalController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    ZKNavigationController*journeyNav = [[ZKNavigationController alloc]initWithRootViewController:personalController];
    
    [controllers addObject:journeyNav];
    
    self.tabBarController.viewControllers = controllers;
    self.tabBarController.customizableViewControllers = controllers;
    self.tabBarController.tabBar.selectionIndicatorImage = [[UIImage alloc] init];
    self.window.rootViewController = self.tabBarController;
    
}

/**
 设置
 */
- (void)setUpLib
{
    hudConfig();
    // 设置键盘监听管理
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    [keyboardManager setEnable:YES];
    [keyboardManager setKeyboardDistanceFromTextField:0];
    [keyboardManager setEnableAutoToolbar:YES];
    [keyboardManager setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    [keyboardManager setPlaceholderFont:[UIFont systemFontOfSize:14]];
    [keyboardManager setShouldResignOnTouchOutside:NO];
    [keyboardManager setToolbarTintColor:NAVIGATION_COLOR];
}

/**
 版本更新
 */
-(void)checkVersion{
    [self versionInformationQuery];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


/**
 程序退出执行

 @param application application
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if ([ZKUtil obtainBoolForKey:ExitEmptyData])
    {
        [ZKUtil clearCache];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            
        }];
        [[SDImageCache sharedImageCache] clearMemory];//可有可无
    }
}
#import "UIImageView+WebCache.h"

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -UITabBarControllerDelegate--

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if(viewController == [tabBarController.viewControllers objectAtIndex:1])
    {
#if LeShan
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotification:[NSNotification notificationWithName:HOME_BUTTONCLICK object:nil]];
#endif
        
        return NO;
    }
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    
}

/**
 更新查询
 */
- (void)versionInformationQuery
{
    NSString *appItunesUrlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@",TELECOM_ID];
    NSURL *urlS = [NSURL URLWithString:appItunesUrlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlS cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (data.length > 0) {
            //有返回数据
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:Nil];
            
            NSArray *results = [dic objectForKey:@"results"];
            
            if (results.count >0)
            {
                //appStore 版本
                NSString *newVersion = [[[dic objectForKey:@"results"] objectAtIndex:0]objectForKey:@"version"];
                NSString *updateContent = [NSString stringWithFormat:@"更新说明: %@",[[[dic objectForKey:@"results"] objectAtIndex:0]objectForKey:@"releaseNotes"]];
                //本地版本
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                
                if (newVersion && ([newVersion compare:currentVersion] == 1))
                {
                    
                    TBUpdateTooltipView *updataView = [[TBUpdateTooltipView alloc] initShowPrompt:updateContent];
                    [updataView show];
                    
                    
                }
            }
            
        }
        
    }];
    
}

@end
