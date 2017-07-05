//
//  ZKMeteorologicalESRootClass.m
//  Emergency
//
//  Created by 王小腊 on 2017/7/4.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKMeteorologicalESRootClass.h"

@implementation ZKMeteorologicalESRootClass

+ (NSDictionary *)objectClassInArray{
    return @{@"weather" : [ZKMeteorologicalWeather class],@"environmental":[ZKMeteorologicalEnvironmental class]};
}

@end


@implementation ZKMeteorologicalEnvironmental


@end


@implementation ZKMeteorologicalWeather


@end
