//
//  ZKInformationReportedView.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/30.
//  Copyright © 2017年 王小腊. All rights reserved.
//
static NSString *const ZKInformationCollectionViewCellID = @"ZKInformationCollectionViewCellID";

#import "ZKInformationReportedView.h"
#import "ZKInformationCollectionViewCell.h"
#import "ZKInformationUploadTool.h"
#import "TBChoosePhotosTool.h"
#import "IQTextView.h"
#import "TBMoreReminderView.h"

@interface ZKInformationReportedView ()<UITextViewDelegate,TBChoosePhotosToolDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
// 属性
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewsWidth;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;// 标题
@property (weak, nonatomic) IBOutlet UITextField *scenicTextfield;// 景区
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;// 人员名称
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;// 电话
@property (weak, nonatomic) IBOutlet IQTextView *infoTextView;// 内容信息
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioWidth;
@property (weak, nonatomic) IBOutlet UIButton *audioButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
// 最大选择数
@property (assign, nonatomic) NSInteger maxRow;
// 横排数量
@property (assign, nonatomic) NSInteger horizontalRow;;
// 默认无照片显示数量
@property (assign, nonatomic) NSInteger defaultRow;
// 默认图
@property (strong, nonatomic) NSString *defaultName;
// 图片尺寸
@property (assign, nonatomic) CGFloat  cellSize;
// 数据上传类
@property (nonatomic, strong) ZKInformationUploadTool *uploadTool;
// 相片选择工具
@property (nonatomic, strong) TBChoosePhotosTool *photoTool;
@end
@implementation ZKInformationReportedView

- (TBChoosePhotosTool *)photoTool
{
    if (!_photoTool)
    {
        _photoTool = [[TBChoosePhotosTool alloc] init];
        _photoTool.delegate = self;
    }
    return _photoTool;
}
- (ZKInformationUploadTool *)uploadTool
{
    if (!_uploadTool)
    {
        _uploadTool = [[ZKInformationUploadTool alloc] init];
    }
    return _uploadTool;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.scrollViewsWidth.constant  =_SCREEN_WIDTH;
    self.submitButton.layer.cornerRadius = 4;
    self.infoTextView.delegate = self;
    // 参数配置
    self.maxRow = 8;
    self.horizontalRow = 4;
    self.defaultRow = 1;
    self.defaultName = @"tianjiaTP";
    self.cellSize = (_SCREEN_WIDTH - 8*(self.horizontalRow+1) - 36.5)/self.horizontalRow;
    self.audioHeight.constant = self.audioWidth.constant = self.cellSize;
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    [flowlayout setItemSize:CGSizeMake(self.cellSize, self.cellSize)];
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowlayout.minimumInteritemSpacing = 8;
    flowlayout.minimumLineSpacing = 8;
    flowlayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    
    self.photoCollectionView.backgroundColor = [UIColor whiteColor];
    self.photoCollectionView.dataSource = self;
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.bounces = NO;
    self.photoCollectionView.scrollEnabled = NO;
    self.photoCollectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.photoCollectionView registerClass:[ZKInformationCollectionViewCell class] forCellWithReuseIdentifier:ZKInformationCollectionViewCellID];
    self.photoCollectionView.collectionViewLayout = flowlayout;
    [self reloadCollectionView];
}
/**
 获取 - ZKInformationReportedView
 
 @return ZKInformationReportedView
 */
+ (ZKInformationReportedView *)obtainReportedView;
{
    ZKInformationReportedView *view = [[NSBundle mainBundle] loadNibNamed:@"ZKInformationReportedView" owner:nil options:nil].lastObject;

    view.clipsToBounds = YES;
    return view;
}
#pragma mark  ----逻辑处理区域----
/**
 刷新CollectionView
 */
- (void)reloadCollectionView
{
    NSInteger number = self.uploadTool.dataArray.count/self.horizontalRow;
    
    if (number<self.maxRow/self.horizontalRow)
    {
        number++;
    }
    if (number == 0) {
        number++;
    }
    CGFloat constant = 8+ self.cellSize*number+ 8*number;
    
    self.photoViewHeight.constant = constant;
    [self.photoCollectionView reloadData];
}
// 选择照片
- (void)choosePhotos
{
   [self.photoTool showPhotosIndex:self.maxRow-self.uploadTool.dataArray.count];
}
// 提示是否删除图片
- (void)friendlyPromptIndex:(NSInteger)dex
{
    [self endEditing:YES];
    YJWeakSelf
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲，是否删除当前图片?"];
    [more showHandler:^{
        [weakSelf.uploadTool.dataArray removeObjectAtIndex:dex];
        [weakSelf reloadCollectionView];
    }];
    
}
#pragma mark  ----按钮点击事件----
/**
 景区数据选择
 */
- (IBAction)scenicSpotDataSelection
{
    
}
// 音频按钮
- (IBAction)audioClick:(UIButton *)sender
{
}
// 视频按钮
- (IBAction)videoClick:(UIButton *)sender
{
}
// 提交上传
- (IBAction)submitClick:(UIButton *)sender
{
    
}
#pragma mark  ----UICollectionViewDataSource----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.uploadTool.dataArray.count == self.maxRow)
    {
        return self.uploadTool.dataArray.count;
    }
    else
    {
        NSInteger tatol = self.uploadTool.dataArray.count+self.defaultRow;
        NSInteger validationRow = self.maxRow - tatol;
        return validationRow <0?self.maxRow:tatol;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZKInformationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZKInformationCollectionViewCellID forIndexPath:indexPath];
    
    if (indexPath.row<self.uploadTool.dataArray.count)
    {
        [cell valueCellImage:self.uploadTool.dataArray[indexPath.row] showDelete:YES index:indexPath.row];
    }
    else
    {
        [cell valueCellImage:[UIImage imageNamed:self.defaultName] showDelete:NO index:indexPath.row];
    }
    YJWeakSelf
    [cell setDeleteCell:^(NSInteger row)
     {
         [weakSelf friendlyPromptIndex:row];
         
     }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self endEditing:YES];
    if (indexPath.row<self.uploadTool.dataArray.count)
    {
        ZKInformationCollectionViewCell *cell = (ZKInformationCollectionViewCell*)[self.photoCollectionView cellForItemAtIndexPath:indexPath];
        
        [self.photoTool showPreviewPhotosArray:self.uploadTool.dataArray baseView:cell.backImageView selected:indexPath.row];
    }
    else
    {
        [self choosePhotos];
    }
}

#pragma mark  ----TBChoosePhotosToolDelegate----
- (void)choosePhotosArray:(NSArray<UIImage*>*)images;
{
    if (images.count > 0)
    {
        [self.uploadTool.dataArray addObjectsFromArray:images];
        [self reloadCollectionView];
    }
}
#pragma mark  ----UITextViewDelegate----
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
    
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *toBeString = textView.text;
    NSString *lang = textView.textInputMode.primaryLanguage;
    NSInteger number = 120;
    // 判断汉子 汉子字节不一样
    if ([lang isEqualToString:@"zh-Hans"])
    {
        UITextRange *selectedRange = [textView markedTextRange];
        if (!selectedRange && toBeString.length>number)
        {
            [UIView addMJNotifierWithText:@"字数太多了" dismissAutomatically:YES];
            textView.text = [toBeString substringToIndex:number];
        }
    }
    else if (toBeString.length > number)
    {
         [UIView addMJNotifierWithText:@"字数太多了" dismissAutomatically:YES];
        textView.text = [toBeString substringToIndex:number];
    }
}

@end
