//
//  HomeVC+MobShare.m
//  SportShell
//
//  Created by Toprank on 16/6/28.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "HomeVC+MobShare.h"

//MOb第三方分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "WXApi.h"
@implementation HomeVC (MobShare)


-(void)SetImagename:(NSString *)imagename Text:(NSString *)text ShareUrl:(NSString *)url Title:(NSString *)title AndPlatformType:(MYPlatformType)platform
{
    
    //1、创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text
                                    images:@[imagename]
                                    url:[NSURL URLWithString:url]
                                    title:title
                                    type:SSDKContentTypeAuto];
    
    
    //进行分享
    switch (platform)
    {
        case MYPlatformSubTypeWechatSession:
        {
            if ([WXApi isWXAppInstalled]) {
                [ShareSDK share:SSDKPlatformSubTypeWechatSession //微信朋友
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     [self CallbackWithState:state Error:error];
                 }];
            }
            else
            {
                [self AlertMessage:@"未安装微信无法分享"];
            }
            break;
        }
        case MYPlatformSubTypeQQFriend:
        {
            if(QQISEXISTENCE){
            [ShareSDK share:SSDKPlatformSubTypeQQFriend //QQ好友
                 parameters:shareParams
             onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                 [self CallbackWithState:state Error:error];
             }];
            }else
            {
                [self AlertMessage:@"未安装QQ无法分∂享"];
            }
            break;
        }
        case MYPlatformSubTypeQZone:
        {
            if(QQISEXISTENCE || QZONEISEXISTENCE){
            [ShareSDK share:SSDKPlatformSubTypeQZone //QQ空间
                 parameters:shareParams
             onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                 [self CallbackWithState:state Error:error];
             }];
            }else
            {
                [self AlertMessage:@"未安装QQ或QQ空间无法分享"];
            }
            break;
        }
        case MYPlatformSubTypeWechatTimeline:
        {
            if ([WXApi isWXAppInstalled]) {
                [ShareSDK share:SSDKPlatformSubTypeWechatTimeline //微信朋友圈
                    parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     [self CallbackWithState:state Error:error];
                 }];
            }else{
                [self AlertMessage:@"未安装微信无法分享"];
            }
            break;
        }
        default:
            break;
    }
}

/**
 *  分享结果回调
 *
 *  @param state 状态
 *  @param error 错误
 */
- (void)CallbackWithState:(SSDKResponseState)state Error:(NSError *)error
{
    switch (state) {
        case SSDKResponseStateSuccess:
        {
            [self AlertMessage:@"分享成功"];
            break;
        }
        case SSDKResponseStateFail:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                            message:[NSString stringWithFormat:@"%@",error]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            break;
        }
        default:
            break;
    }
}

- (void)AlertMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:message
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
