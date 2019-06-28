//
//  HomeVC+UPPayment.h
//  SportShell
//
//  Created by Toprank on 16/4/17.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "HomeVC.h"
#import "UPPaymentControl.h"
@interface HomeVC (UPPayment)
/**
 *  调用银联支付
 */
- (void)UPPayment;
@end
