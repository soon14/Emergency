//
//  ZKAttractionsDetailViewMode.m
//  Emergency
//
//  Created by 王小腊 on 2017/7/6.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKAttractionsDetailViewMode.h"

@interface ZKAttractionsDetailViewMode ()

@property (nonatomic, strong) NSMutableArray <ZKTimeMonitoringMode *>*videoArray;

@end

@implementation ZKAttractionsDetailViewMode
{
    NSMutableDictionary *_parameter;
}
- (NSMutableArray<ZKTimeMonitoringMode *> *)videoArray
{
    if (!_videoArray)
    {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

/**
 开始请求所有数据
 
 @param parameter 参数
 */
- (void)startRequestAllData:(NSMutableDictionary *)parameter;
{
    _parameter = parameter;
    [self requestScencyDetailsData];
    [self requestVideoData];
}

/**
 请求景区详情数据
 */
- (void)requestScencyDetailsData;
{
    YJWeakSelf
    [ZKPostHttp post:@"appScency/scencyDetails" params:_parameter success:^(id responseObj) {
        
        NSString *state = [responseObj valueForKey:@"state"];
        
        if ([state isEqualToString:@"success"])
        {
            ZKAttractionsDetailList *list = [ZKAttractionsDetailList mj_objectWithKeyValues:[[responseObj valueForKey:@"data"] firstObject]];
            
            if ([weakSelf.delegate respondsToSelector:@selector(attractionsDetailData:)])
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [weakSelf.delegate attractionsDetailData:list];
                }];
            }
        }
        else
        {
            [UIView addMJNotifierWithText:@"景区详情数据异常!" dismissAutomatically:YES];
        }
        
    } failure:^(NSError *error)
     {
         [UIView addMJNotifierWithText:@"网络异常！" dismissAutomatically:YES];
     }];
}

/**
 请求视频数据
 */
- (void)requestVideoData;
{
    YJWeakSelf
    [ZKPostHttp post:@"appVideo/videoList" params:_parameter success:^(id responseObj) {
        
        NSString *state = [responseObj valueForKey:@"state"];
        NSString *message = [responseObj valueForKey:@"message"];
        
        if ([state isEqualToString:@"success"])
        {
            [weakSelf responseData:responseObj];
        }
        else
        {
            [UIView addMJNotifierWithText:message dismissAutomatically:YES];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}
// 数据处理
- (void)responseData:(NSDictionary *)obj
{
    [self.videoArray removeAllObjects];
    NSArray *data   = [obj valueForKey:@"data"];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZKTimeMonitoringMode *mode = [[ZKTimeMonitoringMode alloc] initDictionary:obj];
        [self.videoArray addObject:mode];
    }];
    
    if ([self.delegate respondsToSelector:@selector(attractionsVideoData:)])
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.delegate attractionsVideoData:self.videoArray];
        }];
    }
    
}
@end

@implementation ZKAttractionsDetailList

@end


