

#import "WxBackVC.h"
//常量
#import "Const.h"
@interface WxBackVC ()

@end

@implementation WxBackVC
@synthesize errCode;
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化导航栏
    [self initnav];
    AppDelegate * appdelegate = [[UIApplication sharedApplication] delegate];
    if(appdelegate.wxIsReturnResq == 1){
        if (errCode <= 0) {
            if (errCode== 0) {
                self.msg = @"您支付成功";
            }else if (errCode == -1){
                self.msg = @"对不起，支付失败";
            }else if (errCode== -2){
                self.msg = @"您取消了支付";
            }
        }else{
            self.msg = @"";
        }
        [self initAlert];
    }
    if(appdelegate.ylIsReturnResq == 1)
    {
        //设置倒计时总时长
        self.secondsCountDown = 10;//60秒倒计时
        //开始倒计时
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
        
        //设置倒计时显示的时间
        self.titleLabel.text = @"支付信息读取中..(10秒)";
        [self initIndicator];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
}
//倒计时方法
-(void)timeFireMethod{
    //倒计时-1
    self.secondsCountDown--;
    //修改倒计时标签现实内容
    self.titleLabel.text = [NSString stringWithFormat:@"支付信息读取中..(%d秒)",self.secondsCountDown];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(self.secondsCountDown==0){
        [self.countDownTimer invalidate];
        //停止风火轮
        UIActivityIndicatorView * indicator;
        indicator =(UIActivityIndicatorView *)[self.view viewWithTag:103];
        [indicator stopAnimating];
        
        [self dismissVC];
    }
}

#pragma mark - init

- (void)initAlert
{
    UIAlertView * payalert = [[UIAlertView alloc] initWithTitle:@"支付结果"
                                                        message:self.msg
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    payalert.tag = 101;
    [payalert show];
}

//风火轮初始化
- (void)initIndicator
{
    UIActivityIndicatorView *indicator = nil;
    indicator = (UIActivityIndicatorView *)[self.view viewWithTag:103];
    
    if (indicator == nil) {
        
        //初始化:
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        
        indicator.tag = 103;
        
        //设置显示样式,见UIActivityIndicatorViewStyle的定义
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        
        
        //设置背景色
        indicator.backgroundColor = [UIColor blackColor];
        
        //设置背景透明
        indicator.alpha = 0.5;
        
        //设置背景为圆角矩形
        indicator.layer.cornerRadius = 6;
        indicator.layer.masksToBounds = YES;
        float width = Screenwidth;
        float height = ScreenHeight;
        //设置显示位置
        [indicator setCenter:CGPointMake(width/2.0, height/2.0)];
        
        //开始显示Loading动画
        [indicator startAnimating];
        
        [self.view addSubview:indicator];
    }
    
    //开始显示Loading动画
    [indicator startAnimating];
}
#pragma mark - AlertDeletage
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch(alertView.tag)
    {
        case 101:
            if (buttonIndex == [alertView cancelButtonIndex]) //默认cancelButtonIndex = 0，每个按钮index可设
            {
                [self dismissVC];
            }
            break;
        default:
            break;
    }
}
/**初始化导航栏*/

- (void)initnav{
    //设置nav背景色
    [self.navigationController.navigationBar setBarTintColor:ColorBlack];
    //设置导航栏与视图不重叠
    self.navigationController.navigationBar.translucent = NO;
    float screenwidth=[UIScreen mainScreen].bounds.size.width;
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"支付结果";
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.frame = CGRectMake(10.0, screenwidth/2-70,140, 30.0);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    //    //添加标题
    self.navigationItem.titleView = self.titleLabel;
}


#pragma mark - action
//返回
- (void)dismissVC{
    
    //由于是present过来的，这里使用dismiss方式回去
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
