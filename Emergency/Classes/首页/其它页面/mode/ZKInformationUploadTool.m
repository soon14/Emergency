//
//  ZKInformationUploadTool.m
//  Emergency
//
//  Created by 王小腊 on 2017/7/1.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKInformationUploadTool.h"
#import "TBUploadPromptHUD.h"
@interface ZKInformationUploadTool ()

@property (nonatomic, strong) NSMutableArray *imageArray;
// 参数
@property (nonatomic, strong) NSMutableDictionary *parameter;
@property (nonatomic, strong) TBUploadPromptHUD *uploadPromptHUD;
@property (nonatomic, assign) BOOL isUpload;
@end
@implementation ZKInformationUploadTool
- (TBUploadPromptHUD *)uploadPromptHUD
{
    if (!_uploadPromptHUD)
    {
        _uploadPromptHUD = [[TBUploadPromptHUD alloc] init];
    }
    return _uploadPromptHUD;
}
- (NSMutableArray *)imageArray
{
    if (!_imageArray)
    {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (NSMutableDictionary *)parameter
{
    if (!_parameter) {
        _parameter = [NSMutableDictionary dictionary];
    }
    return _parameter;
}
- (NSMutableArray<UIImage *> *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
/**
 开始验证合法性
 */
- (BOOL)startValidation;
{
    if (self.titleTextField.length == 0)
    {
        [self showNotifierWithText:@"请输入上报标题"];
        return NO;
    }
    if (self.resourcecode.length == 0)
    {
        [self showNotifierWithText:@"请选择上报景区"];
        return NO;
    }
    if (self.nameTextfield.length == 0)
    {
        [self showNotifierWithText:@"请输入上报人员名称"];
        return NO;
    }
    if ([ZKUtil isMobileNumber:self.phoneTextfield] == NO)
    {
        [self showNotifierWithText:@"请输入正确的联系电话"];
        return NO;
    }
    if (self.infoText.length == 0) {
        [self showNotifierWithText:@"上报内容必填"];
        return NO;
    }
    if (self.latitude == 0 || self.longitude == 0)
    {
        [self showNotifierWithText:@"定位异常，请在设置中打开定位权限!"];
        return NO;
    }
    return YES;
}

/**
 开始上传
 
 @param success 是否成功
 */
- (void)startUploadSuccess:(uploadSuccess)success;
{
    self.isUploadSuccess = success;
    
    if ([self startValidation])
    {
        [self uploadData];
    }
}
// 上传
- (void)uploadData
{
    YJWeakSelf
    [self.imageArray removeAllObjects];
    __block NSString *images = @"";
    __block NSString *video  = @"";
    __block NSString *audio  = @"";
    self.isUpload = YES;
    [self.uploadPromptHUD showViewCancelUpload:^{
        weakSelf.isUpload = NO;
        
    }];
    
    dispatch_group_t group = dispatch_group_create();
    
    if (self.dataArray.count > 0)
    {
        // 图片上传
        [self.dataArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if (weakSelf.isUpload == YES)
             {
                 dispatch_group_enter(group);
                 NSData *imgData = UIImageJPEGRepresentation(obj, 0.6);
                 
                 [self updataFileData:imgData fileType:0 success:^(NSString *path) {
                     if (path.length > 0)
                     {
                         [weakSelf.imageArray addObject:path];
                     }
                     [weakSelf hudProgress:0.3/weakSelf.dataArray.count];
                     dispatch_group_leave(group);
                 }];
    
             }
        }];
    }
    
    if (self.videoURL && self.isUpload == YES)
    {
        // 视频上传
        dispatch_group_enter(group);
        NSData *videoData = [NSData dataWithContentsOfURL:self.videoURL];
        [self updataFileData:videoData fileType:1 success:^(NSString *path)
        {
            if (path.length > 0)
            {
                video = path;
            }
            [weakSelf hudProgress:0.2];
            dispatch_group_leave(group);
        }];
        
    }
    if (self.audioData && self.isUpload == YES)
    {
        // 音频上传
        dispatch_group_enter(group);
        [self updataFileData:self.audioData fileType:2 success:^(NSString *path) {
            if (path.length > 0)
            {
                audio = path;
            }
             [weakSelf hudProgress:0.2];
            dispatch_group_leave(group);
        }];
        
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (weakSelf.dataArray.count == weakSelf.imageArray.count && weakSelf.isUpload == YES)
        {
            if (weakSelf.imageArray.count > 0)
            {
                images = [weakSelf.imageArray componentsJoinedByString:@","];
            }
            [weakSelf.parameter removeAllObjects];
            [weakSelf.parameter setValue:audio forKey:@"audio"];//音频
            [weakSelf.parameter setValue:video forKey:@"video"];//视频
            [weakSelf.parameter setValue:images forKey:@"image"];//图片
            [weakSelf.parameter setValue:weakSelf.infoText forKey:@"content"];//事件描述
            [weakSelf.parameter setValue:weakSelf.titleTextField forKey:@"name"];//标题
            [weakSelf.parameter setValue:weakSelf.phoneTextfield forKey:@"phone"];//联系电话
            [weakSelf.parameter setValue:weakSelf.nameTextfield forKey:@"reportyeo"];//上报人
            [weakSelf.parameter setValue:weakSelf.resourcecode forKey:@"unit"];//景区资源编码
            [weakSelf.parameter setValue:[NSNumber numberWithDouble:weakSelf.longitude] forKey:@"longitude"];//经度
            [weakSelf.parameter setValue:[NSNumber numberWithDouble:weakSelf.latitude] forKey:@"latitude"];//纬度
            [weakSelf.parameter setValue:@"" forKey:@"type"];//预案类别
            [weakSelf collectingInformationReport];
        }
        else
        {
            [weakSelf showNotifierWithText:@"图片上传有遗漏，请稍后再试。"];
        }
        
    });
 
}

/**
 采集信息上报
 */
- (void)collectingInformationReport
{
    [self hudProgress:0.8];
    YJWeakSelf
    [ZKPostHttp post:@"appEmergency/saveEmergency" params:self.parameter success:^(id responseObj)
     {
         NSString *state = [responseObj valueForKey:@"state"];
         BOOL success = [state isEqualToString:@"success"];

         if (success == YES)
         {
             [weakSelf hudShowMsg:@"上报成功"];
         }
         else
         {
             [weakSelf hudUploadErr];
         }
         int64_t delayInSeconds = 0.6;
         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
         dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
             
             if (weakSelf.isUploadSuccess)
             {
                 weakSelf.isUploadSuccess(success);
                 
             }
         });
         
     } failure:^(NSError *error) {
         
          [weakSelf hudUploadErr];
         if (weakSelf.isUploadSuccess)
         {
             weakSelf.isUploadSuccess(NO);
         }
     }];
}
#pragma mark  ----逻辑区域----
/**
 弹出提示框
 
 @param msg 提示信息
 */
- (void)showNotifierWithText:(NSString *)msg
{
    [UIView addMJNotifierWithText:msg dismissAutomatically:YES];
}

/**
 多类型上传
 
 @param data 数据
 @param type 0图片  1视频  2音频
 @param success 成功返回 字符串
 */
- (void)updataFileData:(NSData *)data fileType:(NSInteger)type success:(void(^)(NSString *path))success
{
    if (self.isUpload == NO)
    {
        if (success)
        {
            success(@"");
        }
        return;
    }
    [ZKPostHttp scPpostImage:@"http://file.geeker.com.cn/iosUpload" params:nil dataArray:data type:type success:^(id responseObj, NSInteger dataType) {
        
        NSString *path =[responseObj valueForKey:@"fileUrl"];
        NSLog(@"%@",path);
        if (success)
        {
            success(path);
        }
    } failure:^(NSError *error, NSInteger dataType) {
        
        if (success)
        {
            success(@"");
        }
    }];
}
#pragma mark  ----hud----
- (void)hudUploadErr
{
    YJWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf.uploadPromptHUD uploadErr];;
    });
    
}
- (void)hudShowMsg:(NSString *)msg
{
    YJWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf.uploadPromptHUD uploadSuccessful:msg];
    });
    
}
- (void)hudProgress:(CGFloat)progress
{
    YJWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf.uploadPromptHUD progress:progress];
    });
}
@end
