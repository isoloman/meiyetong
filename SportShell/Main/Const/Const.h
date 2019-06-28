

#ifndef Const_h
#define Const_h
#import <Foundation/Foundation.h>

/**
 *  屏幕大小
 */

#define ScreenHeight [UIScreen mainScreen].bounds.size.height;
#define Screenwidth [UIScreen mainScreen].bounds.size.width;

/**
 *  银联支付的宏定义
 */

#define kVCTitle @"商户测试"
#define kBtnFirstTitle @"获取订单，开始测试"
#define kWaiting @"正在获取TN,请稍后..."
#define kNote @"提示"
#define kConfirm @"确定"
#define kErrorNet @"网络错误"
#define kResult @"支付结果：%@"

/**
 *  微信支付的宏定义
 */

//商家向财付通申请的商家id
#define KWechatPARTNER_ID @""
//商户密钥
#define KWechatPARTNER_KEY @""
// APPID (微信支付入驻成功后，微信后台返回的回调(URL Schemes ))
#define KWechatAPP_ID @""


//颜色
#define ColorBlack [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0]
//#define ColorBlack [UIColor colorWithRed:246 / 255.0 green:171 / 255.0 blue:0 / 255.0 alpha:1.0]
/**
 *  导航地图的宏定义
 */

// app名称
#define APPNAME @"MLFJSAPP"
//判断是否安装地图
#define GDISEXISTENCE                                                          \
  [[UIApplication sharedApplication]                                           \
      canOpenURL:[NSURL URLWithString:@"iosamap://"]]
#define BDISEXISTENCE                                                          \
  [[UIApplication sharedApplication]                                           \
      canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]
//高德apikey
#define GDAPIKEY @""
//高德地图tableid
#define TABLEID @""

/**
 *  极光推送的宏定义
 */
//80
//#define JGAPIKEY @""
//#define CHANNEL @"App Store"
////188
#define JGAPIKEY  @""
#define CHANNEL  @"App Store"


/**
 *  MobShare第三方平台分享宏定义
 */
//测试
//#define MobAppkey @"iosv1101"
//正式
#define MobAppkey @""

/**
 *  QQ宏定义
 */
#define KQQAPP_ID @""
#define KQQAPP_KEY @""

//判断是否安装QQ
#define QQISEXISTENCE                                                          \
[[UIApplication sharedApplication]                                           \
canOpenURL:[NSURL URLWithString:@"mqq://"]]
//判断是否安装QQ空间
#define QZONEISEXISTENCE                                                          \
[[UIApplication sharedApplication]                                           \
canOpenURL:[NSURL URLWithString:@"mqzone://"]]

//分享平台枚举
typedef NS_ENUM(NSUInteger, MYPlatformType ) {
    /**
     *  微信好友
     */
    MYPlatformSubTypeWechatSession    = 0,
    /**
     *  QQ好友
     */
    MYPlatformSubTypeQQFriend         = 1,
    /**
     *  QQ空间
     */
    MYPlatformSubTypeQZone            = 2,
    /**
     *  微信朋友圈
     */
    MYPlatformSubTypeWechatTimeline   = 3
};


#endif /* Const_h */


@interface AppConfig: NSObject{
    
}
+(NSString *)Protocal;
+(NSString *)BaseUrl;
+(NSString *)IPAndPort;
+(NSString *)FileUpLoad;
+(NSString *)PublicLoad;
+(NSString *)JLRZUrl;
+(NSString *)JLZLUrl;
+(NSString *)SRMXUrl;
+(NSString *)Config_WDDD;
+(NSString *)Config_JSDD;
+(NSString *)Config_HYK;
+(NSString *)Config_COACH;

@end
