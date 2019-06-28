//
//  HomeVC+MobShare.h
//  SportShell
//
//  Created by Toprank on 16/6/28.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC (MobShare)

/**
 *  设置并分享健康播报
 *
 *  @param imagename 分享图片地址
 *  @param text      分享内容
 *  @param url       分享地址
 *  @param title     分享标题
 *  @param platform  分享平台
 */
-(void)SetImagename:(NSString *)imagename Text:(NSString *)text ShareUrl:(NSString*)url Title:(NSString *)title AndPlatformType:(MYPlatformType)platform;
@end
