//
//  HomeVC+JPush.m
//  SportShell
//
//  Created by Toprank on 16/4/27.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "HomeVC+JPush.h"

@implementation HomeVC (JPush)

- (void)SetAlias:(NSString *)alias
{
    [JPUSHService setAlias:alias
          callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                    object:self];
}

/**
 *  回调结果返回
 *
 *  @param iResCode 结果代码
 *  @param tags     名称
 *  @param alias    别名
 */
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d,", iResCode];
    
    NSLog(@"Alias回调:%@", callbackString);
}
@end
