//
//  ZKInformationReportedView.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/30.
//  Copyright © 2017年 王小腊. All rights reserved.
//


#import "ZKInformationReportedView.h"
#import "ShootVideoViewController.h"
#import "PlayVideoViewController.h"
#import "ZKNavigationController.h"
#import "IQTextView.h"
#import "TBMoreReminderView.h"
#import "ZKDataSelectBoxView.h"
#import "ZKInformationCollectionViewCell.h"
#import "D3RecordButton.h"
#import "ZKLocation.h"
#import "ZKInformationUploadTool.h"
#import "TBChoosePhotosTool.h"
#import "ZKBasicDataTool.h"


@interface ZKInformationReportedView ()<UITextViewDelegate,TBChoosePhotosToolDelegate,UICollectionViewDataSource,UICollectionViewDelegate,ZKDataSelectBoxViewDelegate,D3RecordDelegate,AVAudioPlayerDelegate,ZKLocationDelegate,UIScrollViewDelegate>
// 属性
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
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
@property (weak, nonatomic) IBOutlet D3RecordButton *audioButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
//设置成属性
@property (nonatomic, strong) ZKLocation * location;
@property (strong, nonatomic) AVAudioPlayer *player;
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
// 景区上报选择
@property (nonatomic, strong) NSArray *scenicSpotArray;

@end
@implementation ZKInformationReportedView
- (ZKLocation *)location {
    
    if (!_location) {
        
        _location = [[ZKLocation alloc] init];
        
        _location.delegate = self;
    }
    return _location;
}
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
    self.contentScrollView.delegate = self;
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
    // 录音按钮设置
    [self.audioButton initRecord:self maxtime:120 title:@"松手取消录音"];
    
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
    [self obtainHotScenicSpotData];
    [self startPositioning];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
}

/**
 获取景区类别选择数据
 */
- (void)obtainHotScenicSpotData
{
    YJWeakSelf
    [[ZKBasicDataTool sharedManager] obtainHotScenicSpotData:^(NSArray *scenicSpotData) {
        weakSelf.scenicSpotArray = scenicSpotData;
    }];
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
/**
 更新音频按钮显示
 */
- (void)updataAudioButton
{
    NSString *imageName = self.uploadTool.audioData?@"voice_0.jpg":@"add_aud";
    [self.audioButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

/**
 是否播放音频
 
 @param state 状态
 */
- (void)whetherToPlayAudioState:(BOOL)state;
{
    [self.player stop];
    self.player = nil;
    self.player.delegate = nil;
    
    if (state == YES)
    {
        NSError *error;
        [self objctDataState:YES];
        
        NSData *msData = self.uploadTool.audioData;
        
        if (msData.length < 100)
        {
            self.uploadTool.audioData = nil;
            [self updataAudioButton];
            [UIView addMJNotifierWithText:@"音频出错了！" dismissAutomatically:YES];
        }
        else
        {
            self.player = [[AVAudioPlayer alloc]initWithData:msData error:&error];
            self.player.delegate = self;
            [self.player prepareToPlay];
            self.player.volume = 1.0f;
            [self.player play];
            hudShowLoading(@"正在播放");
        }
    }
    
}

/**
 是否正在播放
 
 @param state 状态
 */
- (void)objctDataState:(BOOL)state
{
    NSString *path = state ? @"voice_1.jpg":@"voice_0.jpg";
    [self.audioButton setBackgroundImage:[UIImage imageNamed:path] forState:UIControlStateNormal];
}
/**
 弹出视频录制vc
 */
- (void)showVideoController
{
    __weak typeof(self)weeSelf = self;
    
    ShootVideoViewController *videoVC = [[ShootVideoViewController alloc]init];
    videoVC.totalTime = 120.0f;
    [videoVC  setVideoPathUrl:^(NSURL *url) {
        
        [weeSelf thumbnailImageForVideo:url];
    }];
    ZKNavigationController *nav = [[ZKNavigationController alloc] initWithRootViewController:videoVC];
    [[ZKUtil getPresentedViewController] presentViewController:nav animated:YES completion:^{
        
    }];
}

/**
 弹出视频播放vc
 */
- (void)showVideoPlayController
{
    PlayVideoViewController *paly = [[PlayVideoViewController alloc] init];
    paly.videoURL = self.uploadTool.videoURL;
    ZKNavigationController *nav = [[ZKNavigationController alloc] initWithRootViewController:paly];
    [[ZKUtil getPresentedViewController] presentViewController:nav animated:YES completion:^{
        
    }];
}

/**
 视频操作提示
 */
- (void)videoTipOperation
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"视频操作" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *ylAlert = [UIAlertAction actionWithTitle:@"预览视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                              {
                                  [self showVideoPlayController];
                              }];
    
    UIAlertAction *psAler = [UIAlertAction actionWithTitle:@"重新拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showVideoController];
    }];
    
    UIAlertAction *deleAler = [UIAlertAction actionWithTitle:@"删除视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.uploadTool.videoURL = nil;
        [self updataVodeoButton];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alert dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [alert addAction:ylAlert];
    [alert addAction:psAler];
    [alert addAction:deleAler];
    [alert  addAction:cancel];
    
    [[ZKUtil getPresentedViewController] presentViewController:alert animated:YES completion:nil];
}
/**
 获取视频首帧图片
 
 @param videoURL 视频地址
 */
- (void)thumbnailImageForVideo:(NSURL *)videoURL {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetImageGenerator.appliesPreferredTrackTransform =YES;        assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    
    CFTimeInterval thumbnailImageTime = 0.0f;
    
    NSError *thumbnailImageGenerationError = nil;
    
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime,60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] :nil;
    
    [self.videoButton setBackgroundImage:thumbnailImage forState:UIControlStateNormal];
    self.uploadTool.videoURL = videoURL;
    [self updataVodeoButton];
}

/**
 更新视频按钮显示
 */
- (void)updataVodeoButton
{
    if (self.uploadTool.videoURL)
    {
        [self.videoButton setImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateNormal];
    }
    else
    {
        [self.videoButton setImage:nil forState:UIControlStateNormal];
        [self.videoButton setBackgroundImage:[UIImage imageNamed:@"add_ved"] forState:UIControlStateNormal];
    }
}

/**
 开始定位
 */
- (void)startPositioning
{
    //开始更新定位
    [self.location beginUpdatingLocation];
}
#pragma mark - 清除documents中的视频文件
-(void)clearMovieFromDoucments
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject]))
    {
        if ([filename isEqualToString:@"tmp.PNG"]) {
            
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
            continue;
        }
        if ([[[filename pathExtension] lowercaseString] isEqualToString:@"mp4"]||
            [[[filename pathExtension] lowercaseString] isEqualToString:@"mov"]||
            [[[filename pathExtension] lowercaseString] isEqualToString:@"png"]) {
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}
/**
 清理数据
 */
- (void)cleanUpData
{
    self.titleTextField.text = @"";
    self.scenicTextfield.text = @"";
    self.nameTextfield.text = @"";
    self.phoneTextfield.text = @"";
    self.infoTextView.text = @"";
    self.uploadTool = [[ZKInformationUploadTool alloc] init];
    [self.photoCollectionView reloadData];
    [self updataAudioButton];
    [self updataVodeoButton];
    [self startPositioning];
    [self  clearMovieFromDoucments];
    // 刷新右边列表
    if (self.listTableViewUpdata)
    {
        self.listTableViewUpdata();
    }
}
#pragma mark  ----按钮点击事件----
/**
 景区数据选择
 */
- (IBAction)scenicSpotDataSelection
{
    [self endEditing:YES];
    if (self.scenicSpotArray.count == 0)
    {
        [UIView addMJNotifierWithText:@"上报景区数据正在加载！" dismissAutomatically:YES];
        [self obtainHotScenicSpotData];
    }
    else
    {
        ZKDataSelectBoxView *boxView = [[ZKDataSelectBoxView alloc] initShowPrompt:@"上报景区选择" data:self.scenicSpotArray cellNameKey:@"sname" selectName:self.scenicTextfield.text];
        boxView.delegate = self;
        [boxView show];
    }
}

// 视频按钮
- (IBAction)videoClick:(UIButton *)sender
{
     [self endEditing:YES];
    if (self.uploadTool.videoURL == nil) {
        
        [self showVideoController];
    }
    else
    {
        [self videoTipOperation];
        
    }
}
// 提交上传
- (IBAction)submitClick:(UIButton *)sender
{
    [self endEditing:YES];
    self.uploadTool.titleTextField = self.titleTextField.text;
    self.uploadTool.nameTextfield = self.nameTextfield.text;
    self.uploadTool.phoneTextfield = self.phoneTextfield.text;
    self.uploadTool.infoText = self.infoTextView.text;
    [self.uploadTool startUploadSuccess:^(BOOL success) {
        
        if (success == YES)
        {
            [self cleanUpData];
        }
    }];
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
    
    if (indexPath.row < self.uploadTool.dataArray.count)
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
#pragma mark  ----UIScrollViewDelegate----
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self endEditing:YES];
}
#pragma mark  ----AVAudioPlayerDelegate----
// 音频播放完成时

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)fla
{
    [self objctDataState:NO];
    hudDismiss();
}
// 解码错误
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    hudDismiss();
    [UIView addMJNotifierWithText:@"音频出错了！" dismissAutomatically:YES];
    self.uploadTool.audioData = nil;
    [self updataAudioButton];
    
}
// 当音频播放过程中被中断时
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    
    [player pause];
    hudDismiss();
}
// 当中断结束时
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    
    if (player != nil)
    {
        [player play];
        hudDismiss();
    }
}

#pragma mark  ----D3RecordDelegate----
- (void)endRecord:(NSData *)voiceData;
{
    self.uploadTool.audioData = voiceData;
    [self updataAudioButton];
}
- (BOOL)isStartVoice;
{
    if (self.uploadTool.audioData)
    {
        /** 测试  **/
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"音频操作" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *stAlert = [UIAlertAction actionWithTitle:@"试听音频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                  {
                                      [self whetherToPlayAudioState:YES];
                                      
                                  }];
        
        UIAlertAction *deleAler = [UIAlertAction actionWithTitle:@"删除音频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self whetherToPlayAudioState:NO];
            self.uploadTool.audioData = nil;
            [self updataAudioButton];
        }];
        
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [alert dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        
        [alert addAction:stAlert];
        [alert addAction:deleAler];
        [alert addAction:cancel];
        
        [[ZKUtil getPresentedViewController] presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    else
    {
        return YES;
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

#pragma mark  ----ZKDataSelectBoxViewDelegate----
/**
 弹出框选中的数据
 
 @param data 数据
 */
- (void)boxViewSelectedData:(NSDictionary *)data;
{
    NSString *resourcecode = [data valueForKey:@"resourcecode"];
    NSString *name = [data valueForKey:@"sname"];
    
    self.scenicTextfield.text = name;
    self.uploadTool.resourcecode = resourcecode;
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
#pragma mark  ----ZKLocationDelegate----
- (void)locationDidEndUpdatingLocation:(Location *)location;
{
    self.uploadTool.latitude = location.latitude;
    self.uploadTool.longitude = location.longitude;
}
- (void)dealloc
{
    [self whetherToPlayAudioState:NO];
}
@end
