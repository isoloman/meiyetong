//
//  HomeVC+JPush.h
//  SportShell
//
//  Created by Toprank on 16/4/27.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "HomeVC.h"
#import "JPUSHService.h"

@interface HomeVC (JPush)

/**
 *  设置极光推送别名
 *
 *  @param alias 别名
 */
- (void)SetAlias:(NSString *)alias;
@end
