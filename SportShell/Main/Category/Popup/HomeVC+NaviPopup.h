//
//  HomeVC+NaviPopup.h
//  SportShell
//
//  Created by Toprank on 16/4/14.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "HomeVC.h"
#import "UIPopoverListView.h"
@interface HomeVC (NaviPopup)<UIPopoverListViewDataSource, UIPopoverListViewDelegate>

/**
 *  展示弹出框让用户选择地图导航
 */
- (void)ShowPop;

@end
