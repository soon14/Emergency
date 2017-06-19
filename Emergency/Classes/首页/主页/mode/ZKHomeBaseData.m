//
//  ZKHomeBaseData.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKHomeBaseData.h"

@implementation ZKHomeBaseData

/**
 基础数据请求
 */
+ (void)basicDataRequest;
{

}
/**
 主页加载的内容数据
 
 @return 数据
 */
+ (NSArray <NSDictionary *>*)homeContentData;
{
    NSArray *data = [ZKUtil getUserDataForKey:ZKHomeCellOrder_key];
    
    if (data.count == 0 || data == nil)
    {
        NSMutableArray *moduleArray = [NSMutableArray array];
        [moduleArray addObject:@{@"name":@"实时人数",@"image":@"hombutton_0"}];
        [moduleArray addObject:@{@"name":@"实时监控",@"image":@"hombutton_1"}];
        [moduleArray addObject:@{@"name":@"运营商",@"image":@"hombutton_2"}];
        [moduleArray addObject:@{@"name":@"景区",@"image":@"hombutton_3"}];
        [moduleArray addObject:@{@"name":@"酒店",@"image":@"hombutton_4"}];
        [moduleArray addObject:@{@"name":@"旅行社",@"image":@"hombutton_5"}];
        [moduleArray addObject:@{@"name":@"旅游团队",@"image":@"hombutton_6"}];
        [moduleArray addObject:@{@"name":@"旅游大巴",@"image":@"hombutton_7"}];
        [moduleArray addObject:@{@"name":@"导游",@"image":@"hombutton_8"}];
        [moduleArray addObject:@{@"name":@"电子地图",@"image":@"hombutton_10"}];
        [moduleArray addObject:@{@"name":@"信息采集",@"image":@"hombutton_11"}];
        [moduleArray addObject:@{@"name":@"气象数据",@"image":@"hombutton_12"}];
        [moduleArray addObject:@{@"name":@"环保数据",@"image":@"hombutton_13"}];
        data = moduleArray;
    }
    
    return data;
}
@end
