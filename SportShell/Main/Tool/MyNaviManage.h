

#import <Foundation/Foundation.h>
//常量
#import "Const.h"
#import "AppDelegate.h"
//高德
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface MyNaviManage : NSObject<AMapSearchDelegate,AMapLocationManagerDelegate>
{
    int navitool;
    AMapSearchAPI *_search;
    CGFloat  jd;
    CGFloat  wd;
}
@property (nonatomic, strong) AMapLocationManager *locationManager;

/**
 *  判断地图是否安装
 *
 *  @param type 0 高德 1 百度
 *
 *  @return 标题
 */
- (NSString*)IsExistence:(int)type;

/**
 *  正地理编码
 *
 *  @param address 地址
 *  @param tool    选择的工具 0 高德 1 百度
 */
- (void)GeocodeSearch:(NSString *)address AndNaviTool:(int)tool;

/**
 *  定位
 */
- (void)OnceLocation;
@end
