//
//  MyNaviManage+GaoDeNavi.h
//  SportShell
//
//  Created by Toprank on 16/4/14.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "MyNaviManage.h"
#import <AMapLocationKit/AMapLocationKit.h>
@interface MyNaviManage (GaoDeNavi)

/**
 *  判断是否存在地图导航应用
 *
 *  @return 存在返回打开，不存在返回未下载
 */
- (NSString *)GIsExistence;

/**
 *  通过地址计算地理坐标
 *
 *  @param address 具体地址
 */
- (void)GDGeocodeSearch:(NSString *)address;

/**
 *  定位自身地理坐标
 */
- (void)GDLocation;
/**
 *获取云图数据
 *
 */
-(void)searchCloudMapWithCenterLocationCoordinate;
@end
