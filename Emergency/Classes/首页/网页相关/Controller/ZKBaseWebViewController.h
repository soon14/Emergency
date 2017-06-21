//
//  ZKBaseWebViewController.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/21.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKBaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>


@protocol htmlXY <NSObject,JSExport>
@required

- (void)getHolideDayData:(NSString *)year :(NSString *)time :(NSString *)type  :(NSString*)festevl  :(NSString *)more;

- (void)getHolideDataByMobile:(NSString *)year :(NSString *)time :(NSString *)type  :(NSString*)festevl  :(NSString *)more;

- (void)getDetailHoliday:(NSString*)festevl;

- (void)getHolidayByYear:(NSString*)year;

- (void)getHolidayName:(NSString*)year;

- (void)getAllOperators:(NSString*)year :(NSString*)month;

- (void)getOpratorData:(Boolean)isAll :(NSString *)strType :(NSString *)strTime  :(NSString*)strYear  :(NSString *)strMore;

- (void)getOpratorExtremum;

- (void)getOpratorYears;

- (void)getStatData:(NSString*)type;

- (void)getProtectInfo:(NSString*)time;

- (void)getSceneryToday:(NSString*)code;

- (void)getSceneryHistory:(NSString*)code;

- (void)getSceneriesOneHour;

- (void)getSceneryOneHour:(NSString*)code;

- (void)hrefAndBundle:(NSString*)classpackage;

- (void)getBeforeSeven:(NSString*)month :(NSString*)year;

- (void)showLoading;

- (void)hideLoading;

- (void)errorMsg;

@end

@interface ZKBaseWebViewController : ZKBaseViewController<htmlXY>

/**
 路径
 */
@property (nonatomic, copy) NSURL *pathUrl;

/**
 门禁名称
 */
@property (nonatomic, strong) NSString *htmlTitle;

@end
