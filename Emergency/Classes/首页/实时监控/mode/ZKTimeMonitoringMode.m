//
//  ZKTimeMonitoringMode.m
//  yjPingTai
//
//  Created by 王小腊 on 2017/2/24.
//  Copyright © 2017年 WangXiaoLa. All rights reserved.
//

#import "ZKTimeMonitoringMode.h"

@implementation ZKTimeMonitoringMode
- (instancetype)initDictionary:(NSDictionary *)dic;
{
    self =[super init];
    if (self)
    {
        NSArray *array_0 = [[dic valueForKey:@"mname"] componentsSeparatedByString:@"&"];
        self.mname = [NSMutableArray arrayWithCapacity:array_0.count];
        
        [array_0 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ZKTimeMonitoringVideoMode *mode = [[ZKTimeMonitoringVideoMode alloc] initString:obj];
            [self.mname addObject:mode];
        }];
        self.name = [dic valueForKey:@"name"];
    }
    return self;
}
@end

@implementation ZKTimeMonitoringVideoMode

- (instancetype)initString:(NSString *)str;
{
    self =[super init];
    if (self)
    {
        NSArray *array_0 = [str componentsSeparatedByString:@","];
        
        self.name = array_0.firstObject;
        self.url = [NSString stringWithFormat:@"http://%@",array_0.lastObject]; 
    }
    return self;
}

@end
