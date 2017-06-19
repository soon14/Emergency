//
//  ZKHomeContentView.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKHomeContentView.h"
#import "ZKHomeBaseData.h"
#import "ZKHomeCollectionViewCell.h"

static NSString *const ZKCollectionViewCellID = @"ZKCollectionViewCellID";

@interface ZKHomeContentView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *dataArray;//数据
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong) ZKHomeCollectionViewCell *pressCell;

@end
@implementation ZKHomeContentView
#pragma mark ----懒加载区域---
- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 1;
        _flowLayout.minimumInteritemSpacing = 1;
        CGFloat width = (_SCREEN_WIDTH - 2.1)/3;
        _flowLayout.itemSize = CGSizeMake(width, width + 12);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
        _collectionView.contentInset = UIEdgeInsetsMake(0.0f,0.0f,5.0f,0.0f);
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.delegate = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"ZKHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ZKCollectionViewCellID];
    }
    return _collectionView;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor whiteColor];
        // 加载内容数据
        [self.dataArray addObjectsFromArray:[ZKHomeBaseData homeContentData]];
        [self setUp];
    }
    return self;
}
#pragma mark  -- 视图 && 数据准备 --
- (void)setUp
{
    [self addSubview:self.collectionView];
    YJWeakSelf
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
    [self.collectionView addGestureRecognizer:_longPress];
}
#pragma mark UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZKHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZKCollectionViewCellID forIndexPath:indexPath];
    
    if (self.dataArray.count >0)
    {
        NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
        [cell assignmentCell:dic];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    /***2中排序方式，第一种只是交换2个cell位置，第二种是将后面面的cell都往后移动一格，再将cell插入指定位置***/
    // first
    //    [self.dataArray exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
    
    // second
    NSDictionary *objc = [self.dataArray objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [self.dataArray removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [self.dataArray insertObject:objc atIndex:destinationIndexPath.item];
    
    /**保存数据顺序**/
    [ZKUtil cacheUserValue:self.dataArray.copy key:ZKHomeCellOrder_key];
    [self.collectionView reloadData];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZKHomeCollectionViewCell *cell = (ZKHomeCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.1 animations:^{
        
        cell.frame =CGRectMake(cell.frame.origin.x-2, cell.frame.origin.y-2, cell.frame.size.width+4, cell.frame.size.height+4);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            cell.frame =CGRectMake(cell.frame.origin.x+2, cell.frame.origin.y+2, cell.frame.size.width-4, cell.frame.size.height-4);
        } completion:^(BOOL finished) {
            
            [self cellSelectItemAtIndexPath:indexPath];
        }];
    }];
}

/**
 cell点击
 
 @param indexPath indexPath
 */
- (void)cellSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(homeContentCellClickData:)]) {
        
        NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.delegate homeContentCellClickData:dic];
        }];
    }
}
#pragma mark ---- UILongPressGestureRecognizer ---
- (void)lonePressMoving:(UILongPressGestureRecognizer *)longPress
{
    switch (self.longPress.state) {
        case UIGestureRecognizerStateBegan: {
            {
                NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[_longPress locationInView:self.collectionView]];
                //判断手势落点位置是否在路径上
                if (selectIndexPath == nil) { break; }
                
                // 找到当前的cell
                self.pressCell = (ZKHomeCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:selectIndexPath];
                [self starLongPress:self.pressCell];
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:_longPress.view]];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self.collectionView endInteractiveMovement];
            [self endAnimation];
            break;
        }
        default: [self.collectionView cancelInteractiveMovement];
            [self endAnimation];
            break;
    }
}
#pragma mark  ---- 抖动动画 ----
//开始抖动
- (void)starLongPress:(ZKHomeCollectionViewCell *)cell{
    
    CABasicAnimation *animation = (CABasicAnimation *)[cell.layer animationForKey:@"rotation"];
    
    if (animation == nil)
    {
        [self shakeImage:cell];
    }
    else
    {
        [self resume:cell];
    }
}

- (void)shakeImage:(ZKHomeCollectionViewCell *)cell {
    
    //创建动画对象,绕Z轴旋转
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置属性，周期时长
    [animation setDuration:0.1];
    //抖动角度
    animation.fromValue = @(-M_1_PI/2);
    animation.toValue = @(M_1_PI/2);
    //重复次数，无限大
    animation.repeatCount = HUGE_VAL;
    //恢复原样
    animation.autoreverses = YES;
    //锚点设置为图片中心，绕中心抖动
    cell.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [cell.layer addAnimation:animation forKey:@"rotation"];
    
}
- (void)resume:(ZKHomeCollectionViewCell *)cell {
    cell.layer.speed = 1.0;
}
// 结束动画
- (void)endAnimation
{
    if (self.pressCell)
    {
        [self.pressCell.layer removeAllAnimations];
    }
}

@end
