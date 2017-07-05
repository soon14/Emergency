//
//  ZKRegionSelectCollectionViewCell.m
//  Emergency
//
//  Created by 王小腊 on 2017/7/5.
//  Copyright © 2017年 王小腊. All rights reserved.
//

NSString *const ZKRegionSelectCollectionViewCellID = @"ZKRegionSelectCollectionViewCell";

#import "ZKRegionSelectCollectionViewCell.h"

@interface ZKRegionSelectCollectionViewCell ()


@end
@implementation ZKRegionSelectCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
       
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont systemFontOfSize:13];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLabel];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
    }
    return self;
}

@end
