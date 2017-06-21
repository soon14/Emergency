//
//  ZKBaseWebViewController.m
//  Emergency
//
//  Created by 王小腊 on 2017/6/21.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKBaseWebViewController.h"
#import "UIBarButtonItem+Custom.h"
#import "UIWebView+TS_JavaScriptContext.h"

@interface ZKBaseWebViewController ()<UIWebViewDelegate,TSWebViewDelegate>

@property (nonatomic, strong) UIWebView               *webView;

@property (nonatomic, strong) NSMutableDictionary     *params;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation ZKBaseWebViewController
#pragma mark  ----懒加载----
- (UIActivityIndicatorView *)activityView
{
    if (!_activityView)
    {
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        //设置菊花样式
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _activityView.color = CYBColorGreen;
    }
    return _activityView;
}
- (NSMutableDictionary *)params
{
    if (_params == nil) {
        _params = [NSMutableDictionary dictionary];
        _params[@"format"] = @"json";
    }
    return _params;
}
- (UIWebView *)webView
{
    if (_webView == nil)
    {
        _webView = [[UIWebView alloc] init];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.opaque = NO;
        _webView.dataDetectorTypes = UIDataDetectorTypeNone;
        _webView.delegate = self;
        
    }
    return _webView;
}
#pragma mark  ----设置加载webView----
- (void)setUpWebView
{
    [self.view addSubview:self.webView];
    [self.webView addSubview:self.activityView];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem setRitWithTitel:@"" itemWithIcon:@"backimage" target:self action:@selector(htmlBack)];
    // 加载网页
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.pathUrl]];
    
    YJWeakSelf
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.webView);
        make.width.height.equalTo(@100);
    }];
}
#pragma mark  ----数据请求----
- (void)loadDataMethods:(NSString *)methods requestURL:(NSString *)request
{
    NSString *fun = methods.copy;
    YJWeakSelf
    [ZKPostHttp postPath:request params:self.params success:^(id responseObj) {
        [weakSelf responseObj:responseObj key:fun];
    } failure:^(NSError *error) {
        hudShowError(@"网络异常!");
    }];
}
- (void)responseObj:(id)pam key:(NSString*)key;
{
    if (pam)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            NSString * myString = [[NSString alloc] initWithData:pam encoding:NSUTF8StringEncoding];
            
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"if(APPNAME != undefined) {APPNAME = '%@';}", APPNAME]];
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('%@');",key,myString]];
        }];
    }
}

#pragma mark  ----htmlXY js调用----
/**
 * 显示加载框
 */
- (void)showLoading;
{
    [self.activityView startAnimating];
}
/**
 * 隐藏加载框
 */
- (void)hideLoading;
{
    [self.activityView stopAnimating];
}

/**
 请求错误
 */
- (void)errorMsg;
{
    [self.activityView stopAnimating];
    hudShowError(@"网络异常！");
}
/**
 * 获取联通节假日每天的的数据
 * @param year  年份
 * @param time  具体日期
 * @param type  类型：不传取河北各市州，传了取全国
 * @param festevl   节假日
 * @param more  预留字段
 */
- (void)getHolideDayData:(NSString *)year :(NSString *)time :(NSString *)type  :(NSString*)festevl  :(NSString *)more; {
    
    self.params[@"method"] = @"uninetCountByCity";
    self.params[@"year"] = year;
    self.params[@"type"] = type;
    self.params[@"festevl"] = festevl;
    self.params[@"time"] = time;
    self.params[@"more"] = more;
    
    NSString *fun = type?@"showDayDataInAll":@"showDayDataInHb";
    NSString *url = POST_URL;
    [self loadDataMethods:fun requestURL:url];
}

/**
 * 获取节假日期间移动统计的数据
 * @param year  年份：不传取当年
 * @param type  类型：不传取河北各市州，传了取全国
 * @param festevl   节假日
 * @param more  预留查询条件
 */
- (void)getHolideDataByMobile:(NSString *)year :(NSString *)time :(NSString *)type  :(NSString*)festevl  :(NSString *)more; {
    
    self.params[@"method"] = @"uninetCountByCity";
    self.params[@"year"] = year;
    self.params[@"type"] = type;
    self.params[@"festevl"] = festevl;
    self.params[@"time"] = time;
    self.params[@"more"] = more;
    
    NSString *fun = type?@"showMobileHolidays":@"showMobileHbHolidays";
    NSString *url = POST_URL;
    [self loadDataMethods:fun requestURL:url];
}
/**
 * 获取节假日具体日期
 * @param festevl   节假日
 */
- (void)getDetailHoliday:(NSString*)festevl;
{
    self.params[@"method"] = @"getDay";
    self.params[@"festevl"] = festevl;
    
    NSString *fun = @"showDetailHoliday";
    NSString *url = POST_URL;
    [self loadDataMethods:fun requestURL:url];
}
/**
 *获取全年节假日来津人数
 * @param year  年份
 */
- (void)getHolidayByYear:(NSString*)year;
{
    self.params[@"method"] = @"countByFestevl";
    self.params[@"year"] = year;
    
    NSString *fun = @"showHolidays";
    NSString *url = POST_URL;
    [self loadDataMethods:fun requestURL:url];
}
/**
 *获取节假日名称
 * @param year  年份
 */
- (void)getHolidayName:(NSString*)year;
{
    self.params[@"method"] = @"getFestevl";
    self.params[@"year"] = year;
    
    NSString *fun = @"showHolidays";
    NSString *url = POST_URL;
    [self loadDataMethods:fun requestURL:url];
}
/**
 * 获取月度来访天津全部人数统计
 * @param year  年份：为空则表示取当年
 * @param month 月份：1-12
 */
- (void)getAllOperators:(NSString*)year :(NSString*)month;
{
    self.params[@"method"] = @"searchByOperators";
    self.params[@"year"] = year;
    self.params[@"month"] = month;
    
    NSString *fun = @"showAllOperators";
    NSString *url = POST_URL;
    [self loadDataMethods:fun requestURL:url];
}
/**
 * 移动季度、联通月度来津人数统计
 * @param isAll true.取全部 false.取河北
 * @param strType 2.联通 3.移动
 * @param strTime 当type为2时，time为1-12月；当type为3时，time为1-4季度
 * @param strYear 不传参数默认查询今年
 * @param strMore 不传默认取7条，传了取30个省市或河北全部区县
 */
- (void)getOpratorData:(Boolean)isAll :(NSString *)strType :(NSString *)strTime  :(NSString*)strYear  :(NSString *)strMore; {
    
    self.params[@"method"] = isAll?@"mobileByQuarter":@"HBmobileByQuarter";
    self.params[@"type"] = strType;
    self.params[@"time"] = strTime;
    self.params[@"year"] = strYear;
    self.params[@"more"] = strMore;
    
    NSString *fun = strType ? @"mobileData":@"mobileHBData";
    NSString *url = POST_URL;
    [self loadDataMethods:fun requestURL:url];
}
/**
 * 获取运营商页面的最值
 */
- (void)getOpratorExtremum;
{
    NSString *fun = @"extremum";
    NSString *url = [NSString stringWithFormat:@"%@%@",POST_URL,@"appPeopleCounting/minAndMax"];
    [self loadDataMethods:fun requestURL:url];
    
}
/**
 * 年度来X统计
 */
- (void)getOpratorYears;
{
    NSString *fun = @"yearComming";
    NSString *url = [NSString stringWithFormat:@"%@%@",POST_URL,@"appPeopleCounting/realByMonth"];
    [self loadDataMethods:fun requestURL:url];
    
}
/**
 *  获取投集团
 *
 *  @param month -
 *  @param year -
 */
- (void)getBeforeSeven:(NSString*)month :(NSString*)year;
{
    self.params[@"month"] = month;
    self.params[@"year"] = year;
    
    NSString *fun = @"beforeSeven";
    NSString *url = [NSString stringWithFormat:@"%@%@",POST_URL,@"appPeopleCounting/queryCountByYearMonth"];
    [self loadDataMethods:fun requestURL:url];
}
/**
 * 获取资源统计数据
 * @param type 类型
 */
- (void)getStatData:(NSString*)type;
{
    NSInteger number = type.integerValue;
    NSString *url;
    
    switch (number) {
        case 1:
            url = [NSString stringWithFormat:@"%@%@",POST_URL,@"appHotel/hotelGroup"];
            break;
        case 2:
            url = [NSString stringWithFormat:@"%@%@",POST_URL,@"appTravel/travelGroup"];
            break;
        case 3:
            url = [NSString stringWithFormat:@"%@%@",POST_URL,@"appScency/scencyGroup"];
            break;
        case 4:
            url = [NSString stringWithFormat:@"%@%@",POST_URL,@"appGuide/guideGroup"];
            break;
            
        default:
            break;
    }
    NSString *fun = @"resourceData";
    [self loadDataMethods:fun requestURL:url];
    
}
/**
 * 获取环保信息
 * @param time  时间
 */
- (void)getProtectInfo:(NSString*)time;
{
    [self.webView.ts_javaScriptContext evaluateScript:[NSString stringWithFormat:@"protectData('%@');",ProvinceCode]];
}
/**
 * 景区今日累计数据
 * @param code 景区编号（传空字符串则表示取多个景区）
 */
- (void)getSceneryToday:(NSString*)code;
{
    self.params[@"resourcecode"] = [code isEqualToString:@"undefined"]?@"":code;
    
    NSString *fun = [code isEqualToString:@"undefined"]?@"sceneryToday":@"sceneriesToday";
    NSString *url = [NSString stringWithFormat:@"%@%@",POST_URL,@"appRealtimePeople/realSumTime"];
    [self loadDataMethods:fun requestURL:url];
    
}
/**
 * 景区近7天数据
 * @param code 景区编号（传空字符串则表示取多个景区）
 */
- (void)getSceneryHistory:(NSString*)code;
{
    self.params[@"resourcecode"] = [code isEqualToString:@"undefined"]?@"":code;
    
    NSString *fun = code.length>0?@"sceneryHistory":@"sceneriesHistory";
    NSString *url = [NSString stringWithFormat:@"%@%@",POST_URL,@"appRealtimePeople/sevenRealTime"];
    [self loadDataMethods:fun requestURL:url];
    
}
/**
 * 各景区近1小时数据
 */
- (void)getSceneriesOneHour;
{
    self.params = nil;
    
    NSString *fun = @"sceneriesOneHour";
    NSString *url = [NSString stringWithFormat:@"%@%@",POST_URL,@"appRealtimePeople/realTime"];
    
    [self loadDataMethods:fun requestURL:url];
    
}
/**
 * 单个景区今日门禁数据
 * @param code 景区编号（传空字符串则表示取多个景区）
 */
- (void)getSceneryOneHour:(NSString*)code;
{
    self.params[@"resourcecode"] = [code isEqualToString:@"undefined"]?@"":code;
    
    NSString *fun = @"sceneryOneHour";
    NSString *url = [NSString stringWithFormat:@"%@%@",POST_URL,@"appRealtimePeople/todayRealTime"];
    [self loadDataMethods:fun requestURL:url];
    
}

/**
 * 带参数跳转,需要传包名
 *
 * @param classpackage classpackage
 */
- (void)hrefAndBundle:(NSString*)classpackage;
{
    NSArray *array =[classpackage componentsSeparatedByString:@"?"];
    
    NSString *lef = [array[1] componentsSeparatedByString:@"&"][0];
    NSString *rit = [array[1] componentsSeparatedByString:@"&"][1];
    
    
    NSInteger type = [[rit componentsSeparatedByString:@"="] objectAtIndex:1].integerValue;
    
    NSString *level = [[lef componentsSeparatedByString:@"="] objectAtIndex:1];
    
    //    1酒店   2旅行社   3景区   4领队   5导游
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        if (type ==1) {
            
            
        }else if (type ==2){
            
            
            
        }else if (type ==3){
            
            
        }else if (type ==5){
            
            
        }else if (type ==4){
            
            
        }
        
    }];
    
}


#pragma mark  ----TSWebViewDelegate----
- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext*)ctx;
{
    ctx[@"htmlData"] = self;
}
#pragma mark  ----UIWebViewDelegate----
- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    [self.activityView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    [self.activityView stopAnimating];
    NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    self.navigationItem.title = [self isChineseFirst:str]?str:[NSString stringWithFormat:@"%@门禁实时人数",self.htmlTitle];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    [self.activityView stopAnimating];
    hudShowError(@"网页加载异常！");
}
//是否以中文开头(unicode中文编码范围是0x4e00~0x9fa5)
-(BOOL)isChineseFirst:(NSString *)firstStr
{
    int utfCode = 0;
    void *buffer = &utfCode;
    NSRange range = NSMakeRange(0, 1);
    
    BOOL b = [firstStr getBytes:buffer maxLength:2 usedLength:NULL encoding:NSUTF16LittleEndianStringEncoding options:NSStringEncodingConversionExternalRepresentation range:range remainingRange:NULL];
    if (b && (utfCode >= 0x4e00 && utfCode <= 0x9fa5))
        return YES;
    else
        return NO;
}
#pragma mark  ----返回点击----
- (void)htmlBack
{
    if (self.webView.canGoBack == NO) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.webView goBack];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
