//
//  ZKMonitoringCollectionViewCell.h
//  yjPingTai
//
//  Created by 王小腊 on 2017/2/24.
//  Copyright © 2017年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKTimeMonitoringVideoMode;

@interface ZKMonitoringCollectionViewCell : UICollectionViewCell


@property (nonatomic, copy) void(^videoButtonClick)(NSString  *Url);

/**
 赋值cell

 @param list 数据
 */
- (void)updata:(ZKTimeMonitoringVideoMode *)list;
@end
