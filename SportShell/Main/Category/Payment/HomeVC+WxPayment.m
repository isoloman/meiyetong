//
//  HomeVC+WxPayment.m
//  SportShell
//
//  Created by Toprank on 16/4/11.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "Const.h"
#import "HomeVC+WxPayment.h"
@implementation HomeVC (WxPayment)

#pragma mark - 微信支付

- (void)WecharPay:(NSString *)prepayId {
  if ([self ISExistence]) {
    UIAlertView *wxalert = [[UIAlertView alloc]
            initWithTitle:@"提示"
                  message:@"您未安装微信，无法完成微信支付"
                 delegate:self
        cancelButtonTitle:@"确定"
        otherButtonTitles:nil];
    wxalert.tag = 101;
    [wxalert show];
  } else {
    //定义字典
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //根据服务器端编码确定是否转码
    NSStringEncoding enc;
    // if UTF8编码
    // enc = NSUTF8StringEncoding;
    // if GBK编码
    enc = CFStringConvertEncodingToNSStringEncoding(
        kCFStringEncodingGB_18030_2000);
    //调起微信支付
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = KWechatPARTNER_ID;
    req.prepayId = prepayId;

    // 随机码
    srand((unsigned)time(NULL));
    req.nonceStr = [NSString stringWithFormat:@"%d", rand()];

    NSString *stamp = [[NSString stringWithFormat:@"%ld", time(0)]
        stringByAddingPercentEscapesUsingEncoding:enc];
    req.timeStamp = stamp.intValue;
    req.package = @"Sign=WXPay";
    //创建字典
    //    [dict setValue:req.openID forKey:@"appid"];
    [dict setValue:KWechatAPP_ID forKey:@"appid"];
    [dict setValue:req.partnerId forKey:@"partnerid"];
    [dict setValue:req.prepayId forKey:@"prepayid"];
    [dict setValue:req.nonceStr forKey:@"noncestr"];
    [dict setValue:stamp forKey:@"timestamp"];
    [dict setValue:req.package forKey:@"package"];
    //生成签名
    req.sign = [self createMd5Sign:dict];
    [WXApi sendReq:req];
    //日志输出
    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%"
          @"ld\npackage=%@\nsign=%@",
          req.openID, req.partnerId, req.prepayId, req.nonceStr,
          (long)req.timeStamp, req.package, req.sign);
  }
}

/**
 *  创建package签名
 *
 *  @param dict 参数字典
 *
 *  @return 返回计算出的签名字符串
 */
- (NSString *)createMd5Sign:(NSMutableDictionary *)dict {
  NSMutableString *contentString = [NSMutableString string];
  NSArray *keys = [dict allKeys];
  //按字母顺序排序
  NSArray *sortedArray =
      [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
      }];
  //拼接字符串
  for (NSString *categoryId in sortedArray) {
    if (![[dict objectForKey:categoryId] isEqualToString:@""] &&
        ![categoryId isEqualToString:@"sign"] &&
        ![categoryId isEqualToString:@"key"]) {
      [contentString
          appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
      NSLog(@"%@=====%@&", categoryId, [dict objectForKey:categoryId]);
    }
  }

  // partnerId
  NSString *spkey = KWechatPARTNER_KEY;
  //添加key字段
  [contentString appendFormat:@"key=%@", spkey];
  NSLog(@"contentString=%@", contentString);
  //得到MD5 sign签名
  NSString *md5Sign = [WXUtil md5:contentString];
  return md5Sign;
}

/**
 *  判断是否安装微信
 *
 *  @return 返回是否安装
 */
- (BOOL)ISExistence {
  if (![WXApi isWXAppInstalled])
    return YES;
  else
    return NO;
}

@end
