//
//  UIWebView+JavaScriptAlert.h
//  SportShell
//
//  Created by Toprank on 16/4/9.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (JavaScriptAlert)
- (void)webView:(UIWebView *)sender
    runJavaScriptAlertPanelWithMessage:(NSString *)message
                      initiatedByFrame:(id)frame;
- (BOOL)webView:(UIWebView *)sender
    runJavaScriptConfirmPanelWithMessage:(NSString *)message
                        initiatedByFrame:(id)frame;
- (NSString *)webView:(UIWebView *)view
    runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt
                              defaultText:(NSString *)text
                         initiatedByFrame:(id)frame;
@end
