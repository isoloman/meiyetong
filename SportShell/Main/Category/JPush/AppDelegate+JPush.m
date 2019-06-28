//
//  AppDelegate+JPush.m
//  SportShell
//
//  Created by Toprank on 16/4/26.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "AppDelegate+JPush.h"

#import "Const.h"
@implementation AppDelegate (JPush)

- (void)initJPushWith:(NSDictionary *)launchOptions{
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    
    [JPUSHService setupWithOption:launchOptions appKey:JGAPIKEY channel:CHANNEL apsForProduction:YES advertisingIdentifier:nil];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSDictionary *object = [userInfo objectForKey:@"aps"];
    NSString * news = [object objectForKey:@"alert"];
    NSLog(@"收到通知%@",news);
    NSRange range;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if(self.isActive == false){
        range = [news rangeOfString:@"您的资料审核不通过"];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        if (range.length != 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DisAgree" object:nil];
        }
        range = [news rangeOfString:@"您的认证申请已通过"];
        if(range.length != 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Agree" object:nil];
        }
        range = [news rangeOfString:@"提现失败"];
        if(range.length != 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Defeat" object:nil];
        }
        range = [news rangeOfString:@"订单被取消"];
        if(range.length != 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ddqx" object:nil];
        }
        range = [news rangeOfString:@"您有新的健身订单"];
        if(range.length != 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"jsdd" object:nil];
        }
        range = [news rangeOfString:@"私教课程课程转给您，请知悉"];
        if(range.length != 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"jsdd" object:nil];
        }
        range = [news rangeOfString:@"请提醒该会员续卡消费"];
        if(range.length != 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hykxfjl" object:nil];
        }
        range = [news rangeOfString:@"建议提前10-20分钟到店"];
        if(range.length != 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ddqx" object:nil];
        }
        range = [news rangeOfString:@"如已续卡请忽略"];
        if(range.length != 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hyk" object:nil];
        }
    }else
    {
//        range = [news rangeOfString:@"体检报告"];
//        if (range.length != 0) {
//            UILocalNotification *notification;
//            NSTimeInterval time =2;
//            notification = [JPUSHService
//                            setLocalNotification:[[NSDate date] dateByAddingTimeInterval:time]
//                            alertBody:@"您有新的体检报告！"
//                            badge:1
//                            alertAction:@"前去查看"
//                            identifierKey:nil
//                            userInfo:nil
//                            soundName:nil];
//        }else
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReturnData" object:nil];
//        }
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    NSString *notMess = notification.alertBody;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                    message:notMess
                                                   delegate:self
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:notification.alertAction,nil];
    alert.tag = 101;
    [alert show];
//    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 101){
        if(buttonIndex == 1){
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Background" object:nil];
        }
    }
}

/**
 *  接收到自定义消息处理
 *
 *  @param notification 极光消息
 */
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    //NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    //NSDictionary *extra = [userInfo valueForKey:@"extras"];
    
    NSString *currentContent = [NSString
                                stringWithFormat:
                                @"收到自定义消息:content:%@\n",content];
    NSLog(@"%@", currentContent);
    if([content isEqualToString:@"mlf清除缓存"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DelAllCache" object:nil];
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReturnData" object:nil];
    }
    
}


/**
 *  日志信息解析打印
 *
 *  @param dic 数据
 *
 *  @return 解析编码后的数据
 */
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

@end
