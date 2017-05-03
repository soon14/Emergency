//
//  NSDictionary+FixedParams.m
//  slyjg
//
//  Created by 汤亮 on 16/5/16.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "NSDictionary+FixedParams.h"

@implementation NSDictionary (FixedParams)

+ (instancetype)params
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"format"]  = @"json";
    return params;
}

@end
