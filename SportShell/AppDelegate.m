

#import "AppDelegate.h"
#import "HomeVC.h"
#import "WXApi.h"
#import "Const.h"
//微信支付结果界面
#import "WxBackVC.h"
//极光推送分类
#import "AppDelegate+JPush.h"
//MobShare分类
#import "AppDelegate+MobShare.h"
//银联支付
#import "UPPaymentControl.h"
@interface AppDelegate () <WXApiDelegate>
@property (nonatomic, strong) UIImageView * launchImageView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //连接极光推送
    [self initJPushWith:launchOptions];
    //Mob第三方分享初始化
    [self initMobShareWith:launchOptions];
    self.isActive = false;
    //状态栏

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    HomeVC *rootViewController = [[HomeVC alloc] init];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    [self addLaunchImageView];
    
    //向微信注册
    [WXApi registerApp:KWechatAPP_ID];
  return YES;
}

//回调替换的新方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options
{
    [self CheckJumpUrl: url];
    
    NSLog(@"hangdleopen 1 url==%@", url);
    
    NSString *urlstr = [url absoluteString];
    NSRange range = [urlstr rangeOfString:@"returnKey"];
    if (range.length != 0) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    range = [urlstr rangeOfString:@"MLFJSUPPay"];
    if (range.length != 0) {
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            //结果code为成功时，先校验签名，校验成功后做后续处理
            if([code isEqualToString:@"success"]) {
                self.wxIsReturnResq = 0;
                self.ylIsReturnResq = 1;
                WxBackVC * wxbackvc = [[WxBackVC alloc]init];
                UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:wxbackvc];
                [self.window.rootViewController presentViewController:nc animated:YES completion:^{}];
            }
            else if([code isEqualToString:@"fail"]) {
                //交易失败
            }
            else if([code isEqualToString:@"cancel"]) {
                //交易取消
            }
        }];
        
        return YES;
    }
    return YES;
}
#pragma mark - 支付代理
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  [self CheckJumpUrl: url];
    
  NSLog(@"hangdleopen 2 url==%@", url);

  NSString *urlstr = [url absoluteString];
  NSRange range = [urlstr rangeOfString:@"returnKey"];
  if (range.length != 0) {
    return [WXApi handleOpenURL:url delegate:self];
  }
    range = [urlstr rangeOfString:@"MLFJSUPPay"];
    if (range.length != 0) {
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            //结果code为成功时，先校验签名，校验成功后做后续处理
            if([code isEqualToString:@"success"]) {
                self.wxIsReturnResq = 0;
                self.ylIsReturnResq = 1;
                WxBackVC * wxbackvc = [[WxBackVC alloc]init];
                UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:wxbackvc];
                [self.window.rootViewController presentViewController:nc animated:YES completion:^{}];
            }
            else if([code isEqualToString:@"fail"]) {
                //交易失败
            }
            else if([code isEqualToString:@"cancel"]) {
                //交易取消
            }
        }];
        
        return YES;
    }
    return YES;
}

-(BOOL)CheckJumpUrl:(NSURL *)AUrl{
    NSLog(@"统一回调处理url==%@", AUrl);
    NSString *urlstr = [AUrl absoluteString];
    NSRange range = [urlstr rangeOfString:@"mlfsportapp"];
    if (range.length != 0) {
        NSString *sUrl = [urlstr stringByReplacingOccurrencesOfString:@"mlfsportapp://" withString: @""];
        //地址里的http://变成了http//
        sUrl = [sUrl stringByReplacingOccurrencesOfString:@"http//" withString: @"http://"];
        sUrl = [sUrl stringByReplacingOccurrencesOfString:@"https//" withString: @"https://"];
        NSLog(@"%@%@", @"浏览器回调", sUrl);
        NSURL *url = [NSURL URLWithString: sUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        HomeVC *Vc = self.window.rootViewController;
        [Vc.MainWebView loadRequest:request];
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSLog(@"回调处理url==%@", url);
    [self CheckJumpUrl: url];
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - 微信支付回调
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        NSLog(@"支付结果返回参数:%d", resp.errCode);
        self.wxResqCode = resp.errCode;
        self.wxIsReturnResq = 1;
        self.ylIsReturnResq = 0;
        WxBackVC * wxbackvc = [[WxBackVC alloc]init];
        wxbackvc.errCode = resp.errCode;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:wxbackvc];
        [self.window.rootViewController presentViewController:nc animated:YES completion:^{}];
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    
    self.isActive = false;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    self.isActive = true;
}

- (void)applicationWillTerminate:(UIApplication *)application {
  
}

- (void)addLaunchImageView{
    _launchImageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _launchImageView.image = [self getTheLaunchImage];
    [self.window addSubview:_launchImageView];
}

-(UIImage *)getTheLaunchImage{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    if (viewSize.width>viewSize.height) {
        viewSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    NSString *viewOrientation = nil;
    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait))
    {
        viewOrientation = @"Portrait";
        
    }
    else {
        viewOrientation = @"Landscape";
        
    }
    NSString *launchImage = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict){
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if ((CGSizeEqualToSize(imageSize, viewSize)) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]){
            launchImage = dict[@"UILaunchImageName"];
        }

    }
    return [UIImage imageNamed:launchImage];
    
}

- (void)removeLaunchImageView{
    [UIView animateWithDuration:1 animations:^{
        _launchImageView.layer.affineTransform = CGAffineTransformScale(_launchImageView.layer.affineTransform, 1.5, 1.5);
        _launchImageView.alpha = 0.5;
    } completion:^(BOOL finished) {
        [_launchImageView removeFromSuperview];
        _launchImageView.layer.affineTransform = CGAffineTransformIdentity;
    }];
    
}
@end
