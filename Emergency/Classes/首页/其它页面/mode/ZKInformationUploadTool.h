//
//  ZKInformationUploadTool.h
//  Emergency
//
//  Created by 王小腊 on 2017/7/1.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^uploadSuccess)(BOOL success);
/**
 信息上传工具
 */
@interface ZKInformationUploadTool : NSObject
@property (strong, nonatomic) NSString *titleTextField;// 标题
@property (strong, nonatomic) NSString *nameTextfield;// 人员名称
@property (strong, nonatomic) NSString *phoneTextfield;// 电话
@property (strong, nonatomic) NSString *infoText;// 内容信息
@property (strong, nonatomic) NSString *resourcecode;//景区资源编码
@property (assign, nonatomic) double longitude;//经度
@property (assign, nonatomic) double latitude;//纬度

// 图片数组
@property (nonatomic, strong) NSMutableArray <UIImage *>*dataArray;
// 音频
@property (nonatomic, strong) NSData *audioData;
// 视频
@property (nonatomic, strong) NSURL *videoURL;

@property (nonatomic, copy) uploadSuccess isUploadSuccess;
/**
 开始上传

 @param success 是否成功
 */
- (void)startUploadSuccess:(uploadSuccess)success;
@end
