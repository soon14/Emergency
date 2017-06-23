//
//  ZKBaseClassViewMode.m
//  Emergency
//
//  Created by 王小腊 on 2017/5/3.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKBaseClassViewMode.h"

@interface ZKBaseClassViewMode()
{
    struct{
        unsigned int original  :1;
        unsigned int postEnd   :1;
        unsigned int postError :1;
        unsigned int noMore    :1;
    }_delegateFlags;
    
}


@end
@implementation ZKBaseClassViewMode

- (void)setDelegate:(id<ZKBaseClassViewModeDelegate>)delegate
{
    _delegate = delegate;
    
    _delegateFlags.original = [delegate respondsToSelector:@selector(originalData:)];
    _delegateFlags.postEnd = [delegate respondsToSelector:@selector(postDataEnd:)];
    _delegateFlags.postError = [delegate respondsToSelector:@selector(postError:)];
    _delegateFlags.noMore = [delegate respondsToSelector:@selector(noMoreData)];
}
/**
 请求
 
 @param parameter 参数
 */
- (void)postDataParameter:(NSMutableDictionary *)parameter;
{
    YJWeakSelf
    [ZKPostHttp post:self.url params:parameter cacheType:ZKCacheTypeReloadIgnoringLocalCacheData success:^(NSDictionary *obj) {
        
        NSLog(@"\n\n 结果 == \n%@", obj);
        NSString *state = [obj valueForKey:@"state"];
        if ([state isEqualToString:@"success"])
        {
            if (_delegateFlags.original)
            {
                [weakSelf.delegate originalData:obj];
            }
            NSArray *data = [obj valueForKey:@"data"];
            [weakSelf dataCard:data];
            
        }
        else
        {
            if (_delegateFlags.postError)
            {
                [weakSelf.delegate postError:@"数据异常！"];
            }
        }
        
    } failure:^(NSError *error) {
        
        if (_delegateFlags.postError)
        {
            [weakSelf.delegate postError:@"网络异常！"];
        }
    }];
}
- (void)dataCard:(NSArray *)obj
{
    NSArray *root = obj;
    
    if (_delegateFlags.postEnd)
    {
        [self.delegate postDataEnd:root];
    }
    if (root.count < 20)
    {
        if (_delegateFlags.noMore)
        {
            [self.delegate noMoreData];
        }
    }
    
}



@end
