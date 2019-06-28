

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/**是否需要返回微信支付结果 0 不返回 1 返回*/
@property int wxIsReturnResq;
/**是否需要返回银联支付结果 0 不返回 1 返回*/
@property int ylIsReturnResq;
/**微信支付结果code*/
@property int wxResqCode;
/**判断应用是否在完全活动*/
@property BOOL isActive;

- (void)removeLaunchImageView;
@end

