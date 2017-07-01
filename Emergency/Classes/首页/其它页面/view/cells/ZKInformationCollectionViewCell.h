//
//  ZKInformationCollectionViewCell.h
//  Emergency
//
//  Created by 王小腊 on 2017/7/1.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKInformationCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void(^deleteCell)(NSInteger row);

@property (nonatomic, strong) UIImageView *backImageView;

- (void)valueCellImage:(id )image showDelete:(BOOL)show index:(NSInteger)rows;
@end
