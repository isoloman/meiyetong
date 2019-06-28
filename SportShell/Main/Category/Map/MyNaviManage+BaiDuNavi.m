//
//  MyNaviManage+BaiDuNavi.m
//  SportShell
//
//  Created by Toprank on 16/4/14.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "MyNaviManage+BaiDuNavi.h"

@implementation MyNaviManage (BaiDuNavi)

- (NSString*)BIsExistence{
    if(BDISEXISTENCE){
        return @"点击打开";
    }
    else
        return @"未下载(点击下载)";
    
}
@end
