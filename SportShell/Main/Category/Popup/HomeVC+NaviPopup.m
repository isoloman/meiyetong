//
//  HomeVC+NaviPopup.m
//  SportShell
//
//  Created by Toprank on 16/4/14.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "HomeVC+NaviPopup.h"

@implementation HomeVC (NaviPopup)

- (void)ShowPop
{
    //计算屏幕大小
    float screenHeight = ScreenHeight;
    float screenwidth = Screenwidth;
    CGFloat xWidth = screenwidth - 60.0f;
    CGFloat yHeight = 225.0f;
    CGFloat yOffset = (screenHeight - yHeight)/2.0f;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(30, yOffset, xWidth, yHeight)];
    poplistview.delegate = self;
    poplistview.datasource = self;
    poplistview.listView.scrollEnabled = FALSE;
    [poplistview setTitle:@"使用以下方式找到路线"];
    [poplistview show];
}

#pragma mark - UIPopoverListViewDataSource

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:identifier];
    
    
    int row = (int)indexPath.row;
    
    if(row == 0){
        cell.textLabel.text = @"高德地图";
        cell.detailTextLabel.text=[myNaviManage IsExistence:0];
        if([[myNaviManage IsExistence:0] isEqualToString:@"未下载(点击下载)"])
            self.insertGD = 0;
        else
            self.insertGD = 1;
        cell.imageView.frame = CGRectMake(10.0f, 5.0f, 50.0f, 50.0f);
        cell.imageView.image = [UIImage imageNamed:@"ic_gaode.png"];
    }else if (row == 1){
        cell.textLabel.text = @"百度地图";
        cell.detailTextLabel.text=[myNaviManage IsExistence:1];
        if([[myNaviManage IsExistence:1] isEqualToString:@"未下载(点击下载)"])
            self.insertBD = 0;
        else
            self.insertBD = 1;
        cell.imageView.frame = CGRectMake(10.0f, 5.0f, 50.0f, 50.0f);
        cell.imageView.image = [UIImage imageNamed:@"ic_baidu.png"];
    }else if (row == 2){
        cell.textLabel.text = @"苹果地图";
        cell.detailTextLabel.text=@"";
        cell.imageView.frame = CGRectMake(10.0f, 5.0f, 50.0f, 50.0f);
        cell.imageView.image = [UIImage imageNamed:@"ic_apple.png"];
    }
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            if(self.insertGD == 0){
                NSString *urlString = @"https://appsto.re/cn/OGqHB.i";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }
            else{
                NSLog(@"安装了高德");
                [myNaviManage GeocodeSearch:self.address AndNaviTool:(int)indexPath.row];
            }
            break;
        case 1:
            if(self.insertBD == 0){
                NSString *urlString = @"https://appsto.re/cn/ce98A.i";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }
            else{
                NSLog(@"安装了百度");
                [myNaviManage GeocodeSearch:self.address AndNaviTool:(int)indexPath.row];
            }
            break;
        case 2:
            [myNaviManage GeocodeSearch:self.address AndNaviTool:(int)indexPath.row];
            break;
        default:
            break;
    }
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

@end
