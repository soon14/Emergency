//
//  ZKInformationCollectionMode.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/30.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKInformationCollectionMode.h"

@implementation ZKInformationCollectionMode
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    
    // property 属性名称，oldValue 返回数据
    if ([property.name isEqualToString:@"image"])
    {
        return [oldValue componentsSeparatedByString:@","];
        
    }
    return oldValue;
}

@end
