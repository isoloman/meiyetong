//
//  HomeVC+UPPayment.m
//  SportShell
//
//  Created by Toprank on 16/4/17.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "HomeVC+UPPayment.h"

@implementation HomeVC (UPPayment)

- (void)UPPayment{
    if (self.tn != nil && self.tn.length > 0)
    {
        
        NSLog(@"tn=%@",self.tn);
        [[UPPaymentControl defaultControl] startPay:self.tn fromScheme:@"MLFJSUPPay" mode:@"00" viewController:self];
        
    }
}


@end
