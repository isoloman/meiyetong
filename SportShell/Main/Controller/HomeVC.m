


#import "HomeVC.h"

//银联支付
#import "UPPaymentControl.h"
//微信支付分类
#import "HomeVC+WxPayment.h"
//银联支付分类
#import "HomeVC+UPPayment.h"
//弹窗分类
#import "HomeVC+NaviPopup.h"
//极光推送分类
#import "HomeVC+JPush.h"
//相机分类
#import "HomeVC+Camera.h"
//第三方分享分类
#import "HomeVC+MobShare.h"
// keychain
#import "KeychainItemWrapper.h"
#import "MyNaviManage+GaoDeNavi.h"
#import "YCPlaceHolderView.h"

#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define StatusBar_Height                (IPHONE_X ? 44 : 20)


@interface HomeVC () <UIWebViewDelegate>
@property (nonatomic, strong) YCPlaceHolderView * holder;

@end

@implementation HomeVC
@synthesize  tn;
@synthesize gsid,imei,address,appdelegate,activityIndicator,alert,now_url,now_hyid,DoImagecont, MainWebView;

- (void)viewDidLoad {
  [super viewDidLoad];
  //创建webview
  [self initWebView];
    //初始化参数
    [self initParameter];
  //创建测试按钮
//  [self initButton];
    
}

-(void) viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  创建webview
 */
- (void)initWebView {
  //计算屏幕大小
  float screenHeight = ScreenHeight;
  float screenwidth = Screenwidth; 

    webView = [[UIWebView alloc]
      initWithFrame:CGRectMake(0, StatusBar_Height, screenwidth, screenHeight-StatusBar_Height)];
    webView.scrollView.bounces = NO;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.backgroundColor = ColorBlack;
    self.view.backgroundColor = ColorBlack;
    NSString *urlString = [[NSString alloc]initWithFormat:@"%@",[AppConfig IPAndPort]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    webView.delegate = self;
    [self.view addSubview:webView];
    MainWebView = webView;
    
    _holder = [YCPlaceHolderView createYCPlaceHolderViewWithFrame:webView.frame];
    __weak typeof(self) weakSelf = self;
    _holder.block = ^{
        NSString * urlStr = weakSelf.now_url?weakSelf.now_url:[AppConfig IPAndPort];
        [weakSelf.MainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
        [weakSelf.holder removeFromSuperview];
    };
    
}



//异步调用推送函数，不然会导致白屏
-(void)SetAlia:(NSString *)hyid{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [self SetAlias:hyid];
    });
}
/**
 *  初始化参数
 */
-(void)initParameter{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AgreementUrl) name:@"Agree" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DisAgreeUrl) name:@"DisAgree" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DefeatUrl) name:@"Defeat" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ClearCache) name:@"DelAllCache" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DdQxUrl) name:@"ddqx" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JsddUrl) name:@"jsdd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchgsid:) name:@"searchgsid" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector
     (hyk) name:@"hyk" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector
     (coach) name:@"hykxfjl" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TalkBackground) name:@"TalkBackground" object:nil];
    appdelegate = [[UIApplication sharedApplication] delegate];
    myNaviManage = [[MyNaviManage alloc]init];
    appdelegate.wxIsReturnResq = 0;
    onlyone = 0;
}
-(void)hyk
{
    NSString *urlString = [AppConfig Config_HYK];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self->webView loadRequest:request];
    
}
-(void)coach
{
    NSString *urlString = [AppConfig Config_COACH];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self->webView loadRequest:request];
    
}
/**
 *获取gsid
 */
-(void)searchgsid:(id)sender
{
    NSString *gsid = [sender object];
    NSString *headjs = [[NSString alloc] initWithFormat:@"PosiTioning(%@)", gsid];
    [self runJavaScript:headjs];
}
/**
 *  初始化测试按钮
 */
- (void)initButton {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 25, 100, 40)];
    btn.layer.cornerRadius = 5.0f;
    [btn setTitle:@"测试" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self
            action:@selector(TestFunc)
  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)initImg:(NSString *)imgname
{
    UIImage *img = [UIImage imageNamed:imgname];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [self.view addSubview:imgView];
}
#pragma mark - imeiTool

/**
 *  读取手机keychain中存储的imei
 */
- (void)readKeychain {
    KeychainItemWrapper *keychain =
    [[KeychainItemWrapper alloc] initWithIdentifier:@"IMEI" accessGroup:nil];
    imei = [keychain objectForKey:(__bridge id)kSecValueData];
    imei = [imei stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if ([imei isEqualToString:@""]) {
        imei = [self getUUID];
        imei = [imei stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [keychain setObject:imei forKey:(__bridge id)kSecValueData];
    }
    
}

/**
 *  读取手机keychain中存储的hyid
 */
- (void)readKeychainWith:(NSString *)hyid {
    KeychainItemWrapper *keychain =
    [[KeychainItemWrapper alloc] initWithIdentifier:@"HYID" accessGroup:nil];
    now_hyid = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    now_hyid = hyid;
    [keychain setObject:now_hyid forKey:(__bridge id)kSecAttrAccount];
}

/**
 *  uuid生成
 *
 *  @return 返回uuid
 */
- (NSString *)getUUID {
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result =
    (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}


- (void)runJavaScript:(NSString *)js{
    [webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)LoadUrl:(NSString *)AUrl{
    NSURL *url = [NSURL URLWithString:AUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //[webView loadRequest:request];
}

#pragma mark - testFunc

/**
 *  测试函数
 */
- (void)TestFunc {
    [self ClearCache];
}


#pragma mark - webview
/**
 *  url加载完成后
 *
 *  @param webView 控件
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if(!imei){
        [self readKeychain];
    }
    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSString *token=@"";
    for (NSHTTPCookie * cookies in [sharedHTTPCookieStorage cookies])
    {
        if([cookies.name isEqualToString:@"mlftokeninfo"])
        {
            token = cookies.value;
        }
    }
    if(token!=nil && ![token isEqualToString:@""])
    {
        [self GetHyid:token];
    }
    NSString *afterjs = @"SetLoginTime()";
    [self runJavaScript:afterjs];
    
    afterjs =
    [[NSString alloc] initWithFormat:@"SetImeiCookie(\"%@\")", imei];
    [self runJavaScript:afterjs];
    
    afterjs = @"request()";
    [self runJavaScript:afterjs];
    
    if(onlyone == 1){
        afterjs = @"CheckLogin()";
        [self runJavaScript:afterjs];
        NSString *currentversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        afterjs = [[NSString alloc] initWithFormat:@"bbbj(\"%@\")", currentversion];
        [self runJavaScript:afterjs];
        onlyone = 2;
    }
    afterjs = @"document.documentElement.style.webkitUserSelect='none';";
    [self runJavaScript:afterjs];
    afterjs = @"document.documentElement.style.webkitTouchCallout='none';";
    [self runJavaScript:afterjs];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *headjs = [[NSString alloc] initWithFormat:@"ShowAppBbh(%@)", version];
    [self runJavaScript:headjs];
    
    [appdelegate removeLaunchImageView];
    
}
-(void)GetHyid:(NSString *)token
{
    NSString *myurl = [[NSString alloc] initWithFormat:@"%@", [AppConfig PublicLoad]];
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)token, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    NSDictionary *dict = @{@"token" : decodedString};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"CheckLogin", @"func",json, @"parms", nil];
    [AFNTool
     SendPostWithUrl:myurl
     AndParams:dic
     Success:^(id responseObj) {
         NSDictionary *dictionary = [NSJSONSerialization
                                     JSONObjectWithData:responseObj
                                     options:NSJSONReadingMutableContainers
                                     error:nil];
         NSString *hyid = [dictionary valueForKey:@"id"];
         NSString *alias =[imei stringByAppendingString:hyid];
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
             [self SetAlias:hyid];
         });
     }Failure:^(NSError *error)
     {
         NSLog(@"%@",error);
     }];
}
/**
 *  同意教练
 */
- (void)AgreementUrl{
    NSString *urlString = [AppConfig JLZLUrl];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self->webView loadRequest:request];
}

/**
 *  不同意教练
 */
- (void)DisAgreeUrl{
    NSString *urlString = [AppConfig JLRZUrl];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self->webView loadRequest:request];
}

/**
 * 提现失败
 */
- (void)DefeatUrl{
    NSString *urlString = [AppConfig SRMXUrl];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self->webView loadRequest:request];
}
/**
 * 订单取消
 */
-(void)DdQxUrl{
    NSString *urlString = [AppConfig Config_WDDD];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self->webView loadRequest:request];
}
-(void)JsddUrl{
    NSString *urlString = [AppConfig Config_JSDD];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self->webView loadRequest:request];
}

/**
 *  清除缓存
 */
- (void)ClearCache{
    NSLog(@"缓存清除成功！");
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

/**
 *  返回聊天数据
 */
//- (void)ReturnData{
//    NSLog(@"%@",now_url);
//    NSRange range = [now_url rangeOfString:@"gjlb.html"];
//    if (range.length != 0) {
//        [self runJavaScript:@"ReturnData()"];
//    }else
//    {
//        NSLog(@"没有");
//    }
//}

/**
 *  接收到消息提示有聊天消息跳转
 */
-(void)TalkBackground{
    
    //    KeychainItemWrapper *keychain =
    //    [[KeychainItemWrapper alloc] initWithIdentifier:@"HYID" accessGroup:nil];
    //    now_hyid = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    //
    //    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@", LTCKURL,now_hyid];;
    //    NSURL *url = [NSURL URLWithString:urlString];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    [self->webView loadRequest:request];
    //    NSLog(@"now_hyid==============%@", now_hyid);
}

/**
 *  webView链接 中调用OC
 */
- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlStr = request.URL.absoluteString;
    
    if(![urlStr isEqualToString:@"about:blank"])
        now_url = urlStr;
    NSString *encodedstring = [urlStr
                               stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"quest:%@", encodedstring);
    NSRange range;
    //拦截下载图片
    NSRange imagerange = [urlStr rangeOfString:@"attachment/index.php"];
    if (imagerange.length != 0) {
        UIImage *savemyimage = [self getImageFromURL:urlStr];
        UIImageWriteToSavedPhotosAlbum(
                                       savemyimage, self,
                                       @selector(image:didFinishSavingWithError:contextInfo:), nil);
        return NO;
    }
    
    //检测首页加载次数，控制调用订单js次数
    range = [encodedstring rangeOfString:@"index.html"];
    if (range.length != 0 && onlyone == 0) {
        onlyone = 1;
    }
    //检查是否经过退出或重新登陆
    range = [encodedstring rangeOfString:@"login.html"];
    if (range.length != 0) {
        onlyone = 0;
        range = [encodedstring rangeOfString:@"login.html?"];
        if(range.length == 0)
        {
            NSString *urlString = [AppConfig IPAndPort];
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                [self->webView loadRequest:request];
            });
            
        }
    }
    
    //检查是否调用获取版本号
    range = [encodedstring rangeOfString:@"aboutus.html"];
    if (range.length != 0) {
        
    }
    range = [encodedstring rangeOfString:@"coach.html"];
    if (range.length != 0) {
        [myNaviManage OnceLocation];
    }
    //    range = [encodedstring rangeOfString:@"coach-check.html"];
    //    if (range.length != 0) {
    //        [myNaviManage searchCloudMapWithCenterLocationCoordinate];
    //    }
    
    range = [encodedstring rangeOfString:@"mlf;"];
    if (range.length != 0) {
        
        //以分号;分割的url
        NSString *substr = [encodedstring substringFromIndex:range.location];
        NSArray *foo = [substr componentsSeparatedByString:@";"];
        NSString *where = [foo objectAtIndex:1];
        if ([where isEqualToString:@"WxAppPayment"]) {
            //微信支付
            NSString * prepayId = [foo objectAtIndex:2];
            [self WecharPay:prepayId];
            return NO;
        }
        else if ([where isEqualToString:@"Navi"])
        {
            address= [foo objectAtIndex:2];
            //地图导航
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                [self ShowPop];
            });
            
            return NO;
        }//门店收索
        else if([where isEqualToString:@"PosiTioning"])
        {
            [myNaviManage OnceLocation];
            [myNaviManage searchCloudMapWithCenterLocationCoordinate];
            return  NO;
        }
        else if([where isEqualToString:@"UPayment"])
        {
            //银联支付
            tn =[foo objectAtIndex:2];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                [self UPPayment];
            });
            
            return NO;
        }
        else if ([where isEqualToString:@"Push"])
        {
            NSString * userid = [foo objectAtIndex:2];
            NSString * alias = [foo objectAtIndex:3];
            [self readKeychainWith:userid];
            //极光推送设置设备名
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                [self SetAlias:alias];
            });
            
            return NO;
        }
        else if([where isEqualToString:@"ClearPush"])
        {
            //极光推送清空设备名
            return NO;
        }else if([where isEqualToString:@"Camera"])
        {
            //设置用户头像调用相机相关功能
            NSString * type  = [foo objectAtIndex:2];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                [self ActionSheet:type];
            });
            
            //        if([type isEqualToString:@"0"])
            //           [self ActionSheet];
            //        else
            //            [self Camera:type];
            return NO;
        }else if([where isEqualToString:@"DialNo"])
        {
            NSString * phonenum  = [foo objectAtIndex:2];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"tel://%@", phonenum]]];
            return NO;
        }
        else if([where isEqualToString:@"errorhandle"])
        {
            [self ClearCache];
            NSString * sLogUrl = [[NSString alloc] initWithFormat:@"%@%@%@",
                                  [AppConfig Protocal], [AppConfig BaseUrl], @"/common/mobile/loginnew.html?affair=2"];
            NSURL *url = [NSURL URLWithString:sLogUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                [self->webView loadRequest:request];
            });
            
            return NO;
        }
        else if([where isEqualToString:@"CopyText"])
        {
            NSString * sCopyText  = [foo objectAtIndex:2];
            UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
            pastboard.string = sCopyText;
            NSString *sAlertJs = [[NSString alloc] initWithFormat:@"alert('%@')", @"已将链接复制到剪贴板"];
            NSLog(@"%@", sCopyText);
            [self runJavaScript:sAlertJs];
            return NO;
        }
        
        //以井号#分割的url
        NSRange new_range = [encodedstring rangeOfString:@"mlf;"];//匹配得到的下标
        NSString * new_encodedstring = [encodedstring substringFromIndex:(new_range.location +4)];
        NSArray * new_foo = [new_encodedstring componentsSeparatedByString:@"#"];
        NSString * new_where = [new_foo objectAtIndex:0];
        
        if([new_where isEqualToString:@"ShareUrl"])
        {
            //分享网址
            NSString * myurl = [new_foo objectAtIndex:1];
            NSString * mytitle = [new_foo objectAtIndex:2];
            MYPlatformType  myplatformtype = [[new_foo objectAtIndex:3] intValue];
            NSString * myimageurl = [new_foo objectAtIndex:4];
            NSString * myText = [new_foo objectAtIndex:5];
            [self SetImagename:myimageurl Text:myText ShareUrl:myurl Title:mytitle AndPlatformType:myplatformtype];
            return NO;
        }
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (error.code != -999) {
        [self.view addSubview:_holder];
    }
    [appdelegate removeLaunchImageView];
}

#pragma mark - system_func
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{
    if(appdelegate.wxIsReturnResq == 1)
    {
        NSString *headjs = [[NSString alloc] initWithFormat:@"WxPaymentCompleted(\"%d\")", appdelegate.wxResqCode];
        [self runJavaScript:headjs];
        appdelegate.wxIsReturnResq = 0;
    }
    if(appdelegate.ylIsReturnResq == 1)
    {
        NSString *headjs = [[NSString alloc] initWithFormat:@"CheckOrder(\"%@\")", tn];
        NSLog(@"%@",headjs);
        [self runJavaScript:headjs];
        appdelegate.ylIsReturnResq = 0;
    }
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if ([self getIsIpad]) {
        return UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if ([self getIsIpad]) {
        return UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationLandscapeRight;
    }
    return UIInterfaceOrientationPortrait;
}

//如果想要判断设备是ipad，要用如下方法
- (BOOL)getIsIpad
{
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType containsString:@"iPhone"]) {
        //iPhone
        return NO;
    }
    else if([deviceType containsString:@"iPod"]) {
        //iPod Touch
        return NO;
    }
    else if([deviceType containsString:@"iPad"]) {
        //iPad
        return YES;
    }
    return NO;
    
}

@end
