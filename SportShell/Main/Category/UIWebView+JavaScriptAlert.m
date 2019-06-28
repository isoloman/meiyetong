//
//  UIWebView+JavaScriptAlert.m
//  SportShell
//
//  Created by Toprank on 16/4/9.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "UIWebView+JavaScriptAlert.h"

@implementation UIWebView (JavaScriptAlert)

static BOOL status = NO;
static BOOL isEnd = NO;

- (void)webView:(UIWebView *)sender
    runJavaScriptAlertPanelWithMessage:(NSString *)message
                      initiatedByFrame:(id)frame {

  UIAlertView *customAlert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
  [customAlert show];
}

- (NSString *)webView:(UIWebView *)view
    runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt
                              defaultText:(NSString *)text
                         initiatedByFrame:(id)frame {
  return @"";
}

- (BOOL)webView:(UIWebView *)sender
    runJavaScriptConfirmPanelWithMessage:(NSString *)message
                        initiatedByFrame:(id)frame {
  UIAlertView *confirmDiag = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消", nil];

  [confirmDiag show];
  CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
  if (version >= 7.) {
    while (isEnd == NO) {
      [[NSRunLoop mainRunLoop]
          runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
    }
  } else {
    while (isEnd == NO && confirmDiag.superview != nil) {
      [[NSRunLoop mainRunLoop]
          runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
    }
  }
  isEnd = NO;
  return status;
}

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0)
    status = buttonIndex + 1;
  else
    status = buttonIndex - 1;
  isEnd = YES;
}

@end
