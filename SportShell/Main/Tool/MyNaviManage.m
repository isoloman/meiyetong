

#import "MyNaviManage.h"
//高德类别
#import "MyNaviManage+GaoDeNavi.h"
//百度类别
#import "MyNaviManage+BaiDuNavi.h"
@implementation MyNaviManage

- (NSString*)IsExistence:(int)type{
    NSString * title = @"";
    switch (type) {
        case 0:
            title = [self GIsExistence];
            break;
        case 1:
            title = [self BIsExistence];
            break;
        default:
            break;
    }
    return title;
}

- (void)GeocodeSearch:(NSString *)address AndNaviTool:(int)tool{
    navitool = tool;
    [self GDGeocodeSearch:address];
}

- (void)OnceLocation{
    [self GDLocation];
}
@end
