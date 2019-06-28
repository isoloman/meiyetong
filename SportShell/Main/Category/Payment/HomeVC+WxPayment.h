//
//  HomeVC+WxPayment.h
//  SportShell
//
//  Created by Toprank on 16/4/11.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "HomeVC.h"
#import "WXApi.h"
#import "WXUtil.h"

@interface HomeVC (WxPayment)

/**
 *  向微信发送支付订单号请求支付
 *
 *  @param prepayId 支付订单号
 */
- (void)WecharPay:(NSString *)prepayId;

@end
