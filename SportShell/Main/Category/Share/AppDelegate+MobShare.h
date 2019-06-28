//
//  AppDelegate+MobShare.h
//  SportShell
//
//  Created by Toprank on 16/6/27.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "AppDelegate.h"
//微信SDK头文件
#import "WXApi.h"

@interface AppDelegate (MobShare)<WXApiDelegate>

/**
 *  Mob第三方分享初始化
 *
 *  @param launchOptions app信息
 */
- (void)initMobShareWith:(NSDictionary *)launchOptions;

@end
