//
//  AppDelegate+JPush.h
//  SportShell
//
//  Created by Toprank on 16/4/26.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
@interface AppDelegate (JPush)<UIAlertViewDelegate>

/**
 *  初始化极光推送
 *
 *  @param launchOptions app信息
 */
- (void)initJPushWith:(NSDictionary *)launchOptions;

@end
