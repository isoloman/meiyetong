//
//  MyNaviManage+GaoDeNavi.m
//  SportShell
//
//  Created by Toprank on 16/4/14.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "MyNaviManage+GaoDeNavi.h"
#import <MapKit/MapKit.h>

@implementation MyNaviManage (GaoDeNavi)
- (NSString*)GIsExistence{
    if(GDISEXISTENCE)
        return @"点击打开";
    else
        return @"未下载(点击下载)";
    
}


- (void)GDLocation{
    [AMapLocationServices sharedServices].apiKey =GDAPIKEY;
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，可修改，最小2s
    self.locationManager.locationTimeout = 3;
    //   逆地理请求超时时间，可修改，最小2s
    self.locationManager.reGeocodeTimeout = 3;
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == 2)
            {
                return;
            }
        }
        wd=location.coordinate.latitude;
        jd=location.coordinate.longitude;
        NSLog(@"location:%f,%f", wd,jd);
    }];
}

//获取云图数据
- (void)searchCloudMapWithCenterLocationCoordinate{
    [AMapSearchServices sharedServices].apiKey = GDAPIKEY;
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    NSString *tableID = TABLEID;  // 云图的tableID
    AMapCloudPOIAroundSearchRequest *request = [[AMapCloudPOIAroundSearchRequest alloc] init];
    if(jd == 0||wd == 0)
    {
        [self GDLocation];
    }
    request.tableID = tableID;
    request.center = [AMapGeoPoint locationWithLatitude:wd longitude:jd];
    request.radius = 1000;
    request.offset = 100;  // 最多只能获取100条数据
    request.page = 1;  // 第一页
    [_search AMapCloudPOIAroundSearch:request];//发起数据查找
}


- (void)GDGeocodeSearch:(NSString *)address{
    /**开始正地理**/
    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = GDAPIKEY;
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapGeocodeSearchRequest对象，address为必选项，city为可选项
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = address;
    
    //发起正向地理编码
    [_search AMapGeocodeSearch: geo];
    NSLog(@"%d",navitool);
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

- (void)onCloudSearchDone:(AMapCloudSearchBaseRequest *)request response:(AMapCloudPOISearchResponse *)response
{
    NSInteger *jl = 0;
    NSString  *id=nil;
    for(AMapCloudPOI *p in response.POIs)
    {
        NSLog(@"jl:%@",p.customFields);
        if(jl == 0)
        {
            jl = p.distance;
            id=[p.customFields objectForKey:@"gsid"];
        }
        if(jl > p.distance && ![[p.customFields objectForKey:@"ty"]  isEqual:@"0"])
        {
            jl =p.distance;
            id = [p.customFields objectForKey:@"gsid"];
        }
    }
    if(id != nil)
    {
       [[NSNotificationCenter defaultCenter] postNotificationName:@"searchgsid" object:id];
    }
}

/**
 *  实现正向地理编码的回调函数
 *
 *  @param request  请求信息
 *  @param response 返回信息
 */
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    NSLog(@"====================================");
    if(response.geocodes.count == 0)
    {
        return;
    }
    
    //通过AMapGeocodeSearchResponse对象处理搜索结果
    CGFloat  zdjd = 0.0 ;
    CGFloat  zdwd = 0.0 ;
    for (AMapTip *p in response.geocodes) {
        zdjd = p.location.longitude;
        zdwd = p.location.latitude;
        break;
    }
    NSLog(@"zdjd=%f\nzdwd=%f",zdjd,zdwd);
    if(navitool == 0){
        NSString *urlOfSource = [APPNAME stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *urlString = [NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&slat=%f&slon=%f&sname=A&did=BGVIS2&dlat=%f&dlon=%f&dname=B&dev=0&m=0&t=0",urlOfSource,wd,jd,zdwd,zdjd];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }else if(navitool == 1){
        //调用百度地图
        NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&mode=driving&coord_type=gcj02&src=MLFJSAPP",wd,jd,zdwd,zdjd];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }else if(navitool == 2){
//        NSString *urlString = [[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%f,%f&saddr=%f,%f",zdwd, zdjd,wd,jd] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        CLLocationCoordinate2D to;
        to.latitude = zdwd;
        to.longitude = zdjd;
        
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
        toLocation.name = @"医院";
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                       MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    }
}

@end
