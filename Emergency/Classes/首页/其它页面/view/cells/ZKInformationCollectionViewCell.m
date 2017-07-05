//
//  ZKInformationCollectionViewCell.m
//  Emergency
//
//  Created by 王小腊 on 2017/7/1.
//  Copyright © 2017年 王小腊. All rights reserved.
//

NSString *const  ZKInformationCollectionViewCellID = @"ZKInformationCollectionViewCellID";

#import "ZKInformationCollectionViewCell.h"

@implementation ZKInformationCollectionViewCell
{
    UIButton *ritButton;
    
    NSInteger row;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backImageView = [[UIImageView alloc] init];
        self.backImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.backImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.backImageView];
        self.backImageView.layer.masksToBounds = YES;
        self.backImageView.layer.cornerRadius = 4;
        self.backImageView.layer.borderWidth = 0.5;
        self.backImageView.layer.borderColor = CYBColorGreen.CGColor;
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        ritButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ritButton setImage:[UIImage imageNamed:@"task-shanchu"] forState:UIControlStateNormal];
        [ritButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:ritButton];
        
        YJWeakSelf
        [ritButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerX.equalTo(weakSelf.backImageView.mas_right).offset(-5);
             make.centerY.equalTo(weakSelf.backImageView.mas_top).offset(5);
             make.width.height.mas_equalTo(30);
         }];
        
        
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contentView);
            
        }];
    }
    return self;
}

- (void)valueCellImage:(id )image showDelete:(BOOL)show index:(NSInteger)rows;
{
    if ([image isKindOfClass:[UIImage class]])
    {
        self.backImageView.image = image;
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        [ZKUtil downloadImage:self.backImageView imageUrl:image duImageName:@"cellErr"];
    }
    else
    {
        self.backImageView.image = [UIImage imageNamed:@"cellErr"];
    }
    
    ritButton.hidden = !show;
    ritButton.userInteractionEnabled = show;
    row = rows;
}
- (void)deleteClick
{
    
    if (self.deleteCell)
    {
        self.deleteCell(row);
    }
}

@end
