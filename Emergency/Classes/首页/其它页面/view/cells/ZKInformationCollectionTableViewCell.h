//
//  ZKInformationCollectionTableViewCell.h
//  yjPingTai
//
//  Created by Daqsoft-Mac on 15/8/21.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

extern NSString *const ZKInformationCollectionTableViewCellID;
#import "ZKInformationCollectionMode.h"

@protocol ZKInformationCollectionTableViewCellDelegate <NSObject>


@optional
/**
 *  视频和音频点击事件
 *
 *  @param path 路径
 *  @param type 类型
 */
- (void)clickUrl:(NSString*)path dataType:(NSString*)type objc:(UIImageView*)stateImage;

/**
 处理事件

 @param list 数据
 */
- (void)operationEventData:(ZKInformationCollectionMode *)list;

@end

#import <UIKit/UIKit.h>

@interface ZKInformationCollectionTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *searchTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UILabel *contenLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collerctionViewHeight;

@property (weak,nonatomic) id<ZKInformationCollectionTableViewCellDelegate>delegate;

-(void)update:(ZKInformationCollectionMode*)list;


@end
