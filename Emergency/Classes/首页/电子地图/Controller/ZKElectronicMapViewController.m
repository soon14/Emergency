//
//  ZKElectronicMapViewController.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/27.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKElectronicMapViewController.h"

@interface ZKElectronicMapViewController ()

@end

@implementation ZKElectronicMapViewController

#pragma mark  ----数据配置----

/**
 地图配置数据
 
 @param type 资源类型
 @param defaultData 按钮默认值 @{@"left":@"-",@"region":@"-", @"right":@"-",@"level":@"-"}
 */
- (void)mapConfigurationType:(ElectronicMapType)type dataDefaultData:(NSDictionary *)defaultData;
{

}
#pragma mark  ----视图创建----

/**
 创建天地图
 */
- (void)createMapView
{

}

/**
 创建其他视图
 */
- (void)createViews
{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createMapView];
    [self createViews];
    self.navigationItem.title = @"电子地图";
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
