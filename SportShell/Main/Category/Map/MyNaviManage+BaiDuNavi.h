//
//  MyNaviManage+BaiDuNavi.h
//  SportShell
//
//  Created by Toprank on 16/4/14.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "MyNaviManage.h"

@interface MyNaviManage (BaiDuNavi)
/**
 *  判断是否存在地图导航应用
 *
 *  @return 存在返回打开，不存在返回未下载
 */
- (NSString*)BIsExistence;
@end
