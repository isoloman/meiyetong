

#import "Const.h"
static NSString * Protocal = @"http://";//传输协议
#if Enterprise
static NSString * BaseUrl = @"app.meiyetongsoft.com";
#elif BaiYue == 1
static NSString * BaseUrl = @"azhenjing.meiyetongsoft.com/applogin/login.html";
#endif
static NSString * IPadUrl = @"https://iosipad.meiyetongsoft.com/";

@implementation AppConfig
+(NSString *)BaseUrl{
    return BaseUrl;
}

+(NSString *)Protocal{
    return Protocal;
}

+(NSString *)IPAndPort{//首页rul
#if Enterprise
    if ([self getIsIpad]) {
        return IPadUrl;
    }
#endif
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @""];
}
+(NSString *)FileUpLoad{//图片上传url
#if Enterprise
    if ([self getIsIpad]) {
        return IPadUrl;
    }
#endif
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)PublicLoad{
#if Enterprise
    if ([self getIsIpad]) {
        return IPadUrl;
    }
#endif
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)JLRZUrl{
#if Enterprise
    if ([self getIsIpad]) {
        return IPadUrl;
    }
#endif
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)JLZLUrl{
#if Enterprise
    if ([self getIsIpad]) {
        return IPadUrl;
    }
#endif
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)SRMXUrl{
#if Enterprise
    if ([self getIsIpad]) {
        return IPadUrl;
    }
#endif
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)Config_WDDD {
#if Enterprise
    if ([self getIsIpad]) {
        return IPadUrl;
    }
#endif
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)Config_JSDD {
#if Enterprise
    if ([self getIsIpad]) {
        return IPadUrl;
    }
#endif
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)Config_HYK {
#if Enterprise
    if ([self getIsIpad]) {
        return IPadUrl;
    }
#endif
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)Config_COACH {
#if Enterprise
    if ([self getIsIpad]) {
        return IPadUrl;
    }
#endif
   return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}

//如果想要判断设备是ipad，要用如下方法
+ (BOOL)getIsIpad
{
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType containsString:@"iPhone"]) {
        //iPhone
        return NO;
    }
    else if([deviceType containsString:@"iPod"]) {
        //iPod Touch
        return NO;
    }
    else if([deviceType containsString:@"iPad"]) {
        //iPad
        return YES;
    }
    return NO;
    
}

@end
