//
//  ZKInformationCollectionTableViewCell.m
//  yjPingTai
//
//  Created by Daqsoft-Mac on 15/8/21.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

NSString *const ZKInformationCollectionTableViewCellID = @"ZKInformationCollectionTableViewCellID";

#import "ZKInformationCollectionTableViewCell.h"
#import "ZKInformationCollectionViewCell.h"
#import "ZKInformationCollectionMode.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface ZKInformationCollectionTableViewCell ()


@property (nonatomic, strong) ZKInformationCollectionMode *mode;
@end
@implementation ZKInformationCollectionTableViewCell
{
    NSMutableArray *imageArray;
    NSMutableArray *showImageArray;

    float cellWidth;
    
    NSString *voicePath;
    
    NSString *playePath;
    
    UIButton *operationButton;//处理
    
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    cellWidth = (_SCREEN_WIDTH-30-15)/4;
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    [flowlayout setItemSize:CGSizeMake(cellWidth, cellWidth)];
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowlayout.minimumInteritemSpacing = 5;
    flowlayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.collectionViewLayout = flowlayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:NSClassFromString(@"ZKInformationCollectionViewCell") forCellWithReuseIdentifier:ZKInformationCollectionViewCellID];
    _searchTypeLabel.layer.borderWidth = 0.6;
    _searchTypeLabel.layer.borderColor = [UIColor orangeColor].CGColor;
    _searchTypeLabel.layer.cornerRadius = 8;
    imageArray = [NSMutableArray array];
    showImageArray = [NSMutableArray array];
#if guangD
    
    operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [operationButton setTitle:@"处理" forState:UIControlStateNormal];
    [operationButton setTitleColor:CYBColorGreen forState:UIControlStateNormal];
    operationButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [operationButton addTarget:self action:@selector(operationClick) forControlEvents:UIControlEventTouchUpInside];
    operationButton.layer.cornerRadius = 10;
    operationButton.layer.borderColor = CYBColorGreen.CGColor;
    operationButton.layer.borderWidth = 0.5;
    [self addSubview:operationButton];
    
    [operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(20);
        make.top.equalTo(self.mas_top).offset(8);
        make.right.equalTo(self.mas_right).offset(-10);
    }];

#endif
    
}

-(void)update:(ZKInformationCollectionMode*)list;
{
    [imageArray removeAllObjects];
    
    self.mode = list;
#if guangD
    
    if (list.disposeResult.length == 0 || [list.disposeResult isKindOfClass:[NSNull class]])
    {
        operationButton.hidden = NO;
    }
    else
    {
        operationButton.hidden = YES;
    }

#endif
    self.nameLabel.text =list.name;

    self.infoLabel.text =list.content;
    
    self.searchTypeLabel.text = [NSString stringWithFormat:@"  %@  ",list.scencyName];

    [imageArray addObjectsFromArray:list.image];

    if (![list.video isEqualToString:@"无"] && (list.video.length>0))
    {
        [imageArray addObject:@"playe.jpg"];
        playePath = list.video;
    }
    
    
    if (![list.audio isEqualToString:@"无"] && (list.audio.length>0))
    {
        [imageArray addObject:@"voice_0.jpg"];
        voicePath = list.audio;
    }
    
    NSInteger num = 0;
    
    if (imageArray.count == 0 )
    {
        num = 0;
    }
    else if (imageArray.count < 5)
    {
    
        num = 1;
    }
    else if (imageArray.count < 9)
    {
        num = 2;
    }
    else
    {
        num = 3;
    }
    self.contenLabel.text =[NSString stringWithFormat:@"%@(%@) 于 (%@)上报成功",list.reportyeo,list.phone,list.reporttime];
    self.collerctionViewHeight.priority = UILayoutPriorityDefaultHigh;
    self.collerctionViewHeight.constant = num*(cellWidth+5)+8;
    
    [self.collectionView reloadData];
}


#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return imageArray.count;
}

- (ZKInformationCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZKInformationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZKInformationCollectionViewCellID forIndexPath:indexPath];
    
    NSString *imagePath = [imageArray objectAtIndex:indexPath.row];
    
    if ([imagePath isEqualToString:@"voice_0.jpg"]||[imagePath isEqualToString:@"playe.jpg"])
    {
        cell.backImageView.image = [UIImage imageNamed:imagePath];
        [cell valueCellImage:[UIImage imageNamed:imagePath] showDelete:NO index:indexPath.row];
    }
    else
    {
        [cell valueCellImage:[imageArray objectAtIndex:indexPath.row] showDelete:NO index:indexPath.row];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
    
    ZKInformationCollectionViewCell *cell = (ZKInformationCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSString *imagePath = [imageArray objectAtIndex:indexPath.row];
    
    if ([imagePath isEqualToString:@"voice_0.jpg"]||[imagePath isEqualToString:@"playe.jpg"])
    {
       
        NSString *url = [imagePath isEqualToString:@"voice_0.jpg"]?voicePath:playePath;
        
        if ([self.delegate respondsToSelector:@selector(clickUrl:dataType:objc:)])
        {
            [self.delegate clickUrl:url dataType:imagePath objc:cell.backImageView];
        }

    }
    else
    {
        ZKInformationCollectionViewCell *cell =(ZKInformationCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        
        [self imageSelec:indexPath.row :cell.backImageView];
    }
}

//大图
-(void)imageSelec:(NSInteger)index :(UIImageView*)phontImage
{
    [showImageArray removeAllObjects];
    
    [self.mode.image enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.srcImageView = phontImage; // 来源于哪个UIImageView

        photo.url = [NSURL URLWithString:[obj stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]; // 图片路径
        [showImageArray addObject:photo];
    }];
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
    browser.photos = showImageArray; // 设置所有的图片
    [browser show];

}
#pragma mark --- uibutton ---
- (void)operationClick
{
    if ([self.delegate respondsToSelector:@selector(operationEventData:)]) {
        
        [self.delegate operationEventData:self.mode];
    }
}
@end

