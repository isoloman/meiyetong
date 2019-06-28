//
//  HomeVC+Camera.h
//  SportShell
//
//  Created by Toprank on 16/6/23.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "HomeVC.h"
#import "AFNTool.h"
@interface HomeVC (Camera)<UIImagePickerControllerDelegate,UINavigationControllerDelegate,DoImagePickerControllerDelegate,UIActionSheetDelegate>

/**
 *  弹出选择
 */
- (void)ActionSheet:(NSString *)type;


/**
 *  调用相机相关功能
 *
 *  @param type 0 相机 1 相册
 */
- (void)Camera:(NSString *)type;
- (void)test;
/**
 *  从url中获取图片
 *
 *  @param fileURL 图片文件url
 *
 *  @return 返回图片
 */
- (UIImage *)getImageFromURL:(NSString *)fileURL;

/**
 *  保存后成功与否提示
 *
 *  @param image       保存的图片
 *  @param error       错误代码
 *  @param contextInfo 环境信息
 */
- (void)image:(UIImage *)image
didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo;

@end
