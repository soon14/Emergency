//
//  ZKInformationUploadTool.m
//  Emergency
//
//  Created by 王小腊 on 2017/7/1.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKInformationUploadTool.h"

@implementation ZKInformationUploadTool

- (NSMutableArray<UIImage *> *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
