//
//  ZKHomeBannerData.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKHomeImagesData.h"

@interface ZKHomeBannerData : NSObject

@property (nonatomic, strong) NSArray<ZKHomeImagesData *> *data;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, copy) NSString *version;

@end

