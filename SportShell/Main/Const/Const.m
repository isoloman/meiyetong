

#import "Const.h"
static NSString * Protocal = @"http://";//传输协议
#ifdef Enterprise
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
#ifdef Enterprise
    if ([self getIsIpad]) {
        return IPadUrl;
    }
#endif
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @""];
}
+(NSString *)FileUpLoad{//图片上传url
#ifdef Enterprise
    if ([self getIsIpad]) {
        return IPadUrl;
    }
#endif
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)PublicLoad{
#ifdef Enterprise
    if ([self getIsIpad]) {
        return IPadUrl;
    }
#endif
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)JLRZUrl{
#ifdef Enterprise
    if ([self getIsIpad]) {
        return IPadUrl;
    }
#endif
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)JLZLUrl{
#ifdef Enterprise
    if ([self getIsIpad]) {
        return IPadUrl;
    }
#endif
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)SRMXUrl{
#ifdef Enterprise
    if ([self getIsIpad]) {
        return IPadUrl;
    }
#endif
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)Config_WDDD {
#ifdef Enterprise
    if ([self getIsIpad]) {
        return IPadUrl;
    }
#endif
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)Config_JSDD {
#ifdef Enterprise
    if ([self getIsIpad]) {
        return IPadUrl;
    }
#endif
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)Config_HYK {
#ifdef Enterprise
    if ([self getIsIpad]) {
        return IPadUrl;
    }
#endif
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)Config_COACH {
#ifdef Enterprise
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
