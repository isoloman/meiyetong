

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Const.h"
@interface WxBackVC : UIViewController
/**nav标题*/
@property (nonatomic,strong) UILabel * titleLabel;
//微信返回码
@property int errCode;
//倒计时总时长
@property int secondsCountDown;
//计时器
@property NSTimer *countDownTimer;
//弹窗内容s
@property (nonatomic,strong) NSString * msg;
@end
