//
//  AppDelegate+MobShare.m
//  SportShell
//
//  Created by Toprank on 16/6/27.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "AppDelegate+MobShare.h"
//MobShare分享平台
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>



#import "Const.h"
@implementation AppDelegate (MobShare)


-(void)initMobShareWith:(NSDictionary *)launchOptions
{
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //QQ
        [platformsRegister setupQQWithAppId:KQQAPP_ID appkey:KQQAPP_KEY];
        [platformsRegister setupWeChatWithAppId:KWechatAPP_ID appSecret:KWechatPARTNER_KEY];
    }];
    
//    [ShareSDK registerApp:MobAppkey
//          activePlatforms:@[
//                            @(SSDKPlatformSubTypeWechatSession),
//                            @(SSDKPlatformSubTypeWechatTimeline),
//                            @(SSDKPlatformTypeQQ)
//                            ]
//                 onImport:^(SSDKPlatformType platformType) {
//                     
//                     switch (platformType)
//                     {
//                         case SSDKPlatformTypeWechat:
//                            [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
//                             break;
//                         case SSDKPlatformTypeQQ:
//                             [ShareSDKConnector connectQQ:[QQApiInterface class]
//                                        tencentOAuthClass:[TencentOAuth class]];
//                             break;
//                         default:
//                             break;
//                     }
//                 }
//          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
//              
//              switch (platformType)
//              {
//                case SSDKPlatformTypeWechat:
//                      [appInfo SSDKSetupWeChatByAppId:KWechatAPP_ID
//                                            appSecret:KWechatPARTNER_KEY];
//                      break;
//                case SSDKPlatformTypeQQ:
//                      [appInfo SSDKSetupQQByAppId:KQQAPP_ID
//                                           appKey:KQQAPP_KEY
//                                         authType:SSDKAuthTypeBoth];
//                      break;
//                default:
//                      break;
//              }
//          }];
}

@end
