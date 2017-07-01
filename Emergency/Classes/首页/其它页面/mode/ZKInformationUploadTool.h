//
//  ZKInformationUploadTool.h
//  Emergency
//
//  Created by 王小腊 on 2017/7/1.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 信息上传工具
 */
@interface ZKInformationUploadTool : NSObject
@property (strong, nonatomic) NSString *titleTextField;// 标题
@property (strong, nonatomic) NSString *scenicTextfield;// 景区
@property (strong, nonatomic) NSString *nameTextfield;// 人员名称
@property (strong, nonatomic) NSString *phoneTextfield;// 电话
@property (strong, nonatomic) NSString *infoTextView;// 内容信息
// 图片数组
@property (nonatomic, strong) NSMutableArray <UIImage *>*dataArray;
// 音频
@property (nonatomic, strong) NSData *audioData;
// 视频
@property (nonatomic, strong) NSData *videoData;

@end
