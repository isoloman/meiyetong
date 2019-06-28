

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
//常量
#import "Const.h"
#import "MyNaviManage.h"
//极光服务
#import "JPUSHService.h"
//多选图片
#import "DoImagePickerController.h"

@interface HomeVC : UIViewController<UIImagePickerControllerDelegate>
{
    /**webview控件*/
    UIWebView *webView;
    /**导航管理*/
    MyNaviManage * myNaviManage;
    /**只调用一次js的控制字段*/
    int onlyone;
    //图片是否裁剪 1不作处理 0 裁剪
    int imagetype;
}
@property (nonatomic,retain) AppDelegate *appdelegate;

/**
 *  手机imei
 */
@property(nonatomic, retain) NSString *imei;
/**
 *  查找云图返回的gsid
 */
@property(nonatomic, retain) NSString *gsid;
/**
 *  导航目的地地址
 */
@property(nonatomic, retain) NSString *address;

/**
 *  银联支付订单号
 */
@property(nonatomic, copy) NSString *tn;

/**
 *  是否安装了高德地图 0 未安装 1 安装
 */
@property int insertGD;

/**
 *  是否安装了百度地图 0 未安装 1 安装
 */
@property int insertBD;

/**
 *  用户头像名称
 */
@property(nonatomic, retain) NSString *txname;

/**
 *  加载等待
 */
@property(nonatomic, strong) UIActivityIndicatorView *activityIndicator;

/**
 *  提示框
 */
@property(nonatomic, strong) UIAlertView *alert;

/**
 *  当前访问的url
 */
@property(nonatomic,strong) NSString * now_url;

/**
 *  当前会员id
 */
@property(nonatomic,strong) NSString * now_hyid;


/**
 *  当前webview
 */
@property(nonatomic, strong)UIWebView * MainWebView;


/**
 *  调用js
 *
 *  @param jsstr js语句
 */
- (void)runJavaScript:(NSString *)jsstr;


/**
 *  多选图片界面
 */
@property(nonatomic, strong) DoImagePickerController *DoImagecont;

-(void)LoadUrl:(NSString *)AUrl;



@end
