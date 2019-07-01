

#import "Const.h"
static NSString * Protocal = @"http://";//传输协议
static NSString * BaseUrl = @"app.meiyetongsoft.com";
static NSString * IPadUrl = @"https://iosipad.meiyetongsoft.com/";

@implementation AppConfig
+(NSString *)BaseUrl{
    return BaseUrl;
}

+(NSString *)Protocal{
    return Protocal;
}

+(NSString *)IPAndPort{//首页rul
    if ([self getIsIpad]) {
        return IPadUrl;
    }
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @""];
}
+(NSString *)FileUpLoad{//图片上传url
    if ([self getIsIpad]) {
        return IPadUrl;
    }
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)PublicLoad{
    if ([self getIsIpad]) {
        return IPadUrl;
    }
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)JLRZUrl{
    if ([self getIsIpad]) {
        return IPadUrl;
    }
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)JLZLUrl{
    if ([self getIsIpad]) {
        return IPadUrl;
    }
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)SRMXUrl{
    if ([self getIsIpad]) {
        return IPadUrl;
    }
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)Config_WDDD {
    if ([self getIsIpad]) {
        return IPadUrl;
    }
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)Config_JSDD {
    if ([self getIsIpad]) {
        return IPadUrl;
    }
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)Config_HYK {
    if ([self getIsIpad]) {
        return IPadUrl;
    }
    return [[NSString alloc] initWithFormat:@"%@%@%@", Protocal, BaseUrl, @"/"];
}
+(NSString *)Config_COACH {
    if ([self getIsIpad]) {
        return IPadUrl;
    }
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
