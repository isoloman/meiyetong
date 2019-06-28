//
//  HomeVC+Camera.m
//  SportShell
//
//  Created by Toprank on 16/6/23.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "HomeVC+Camera.h"
//多选图片
#import "DoImagePickerController.h"

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
@implementation HomeVC (Camera)



-(void)ActionSheet:(NSString *)type{
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    NSLog(@"%@",type);
    if([type isEqualToString:@"0"])
    {
        actionSheet.tag = 1;
    }else if([type isEqualToString:@"2"]){
        actionSheet.tag = 2;
    }else if([type isEqualToString:@"4"]){
        actionSheet.tag = 3;
    }
    [actionSheet showInView:self.view];
}

- (void)Camera:(NSString *)type {
  if ([self IsCameraCanUse] && [self IsLibraryCanUse]) {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
      if ([type isEqualToString:@"0"] || [type isEqualToString:@"1"]){
           picker.allowsEditing = YES;  //设置可编辑
      }
      else{
           picker.allowsEditing = NO;  //设置不可编辑

      }
    if ([type isEqualToString:@"0"]) {
      if ([UIImagePickerController
              isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;

      } else {
        NSLog(@"模拟器无法打开相机");
      }
      self->imagetype = 0;
      [self presentViewController:picker animated:YES completion:nil];
    } else if ([type isEqualToString:@"1"]) {
        self->imagetype = 0;
      picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
      [self presentViewController:picker animated:YES completion:nil];
    } else if ([type isEqualToString:@"2"]) {
      self.DoImagecont = [[DoImagePickerController alloc]
          initWithNibName:@"DoImagePickerController"
                   bundle:nil];
      self.DoImagecont.delegate = self;
      self.DoImagecont.nMaxCount = 20;    // 2, 3, or 4
      self.DoImagecont.nColumnCount = 4;  //
      self.DoImagecont.nResultType = DO_PICKER_RESULT_UIIMAGE;
      [self presentViewController:self.DoImagecont animated:YES completion:nil];
    } else if ([type isEqualToString:@"3"]) {
      if ([UIImagePickerController
              isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self->imagetype = 1;
      } else {
        NSLog(@"模拟器无法打开相机");
      }
      [self presentViewController:picker animated:YES completion:nil];
    } else if ([type isEqualToString:@"4"]) {
      //从相册选择，不裁剪，不压缩
      self->imagetype = 1;
      picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
      [self presentViewController:picker animated:YES completion:nil];
    }
  }
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",(long)actionSheet.tag);
    if(actionSheet.tag==1)
    {
        if(buttonIndex == 0)
            [self Camera:@"0"];
        else if(buttonIndex == 1)
            [self Camera:@"1"];
        
    }
    else if(actionSheet.tag==2)
    {
        if(buttonIndex == 0)
            [self Camera:@"3"];
        else if(buttonIndex == 1)
            [self Camera:@"2"];
        
    }
    else if(actionSheet.tag==3)
    {
        if(buttonIndex == 0)
            [self Camera:@"3"];
        else if(buttonIndex == 1)
            [self Camera:@"4"];
    }
}




/**
 *  判断相机权限是否有开
 *
 *  @return yes 已授权 no 未授权
 */
- (BOOL)IsCameraCanUse {
  NSString *mediaType = AVMediaTypeVideo;  // Or AVMediaTypeAudio
  AVAuthorizationStatus authStatus =
      [AVCaptureDevice authorizationStatusForMediaType:mediaType];
  if (authStatus == AVAuthorizationStatusRestricted) {
    NSLog(@"Restricted");
    return NO;
  } else if (authStatus == AVAuthorizationStatusDenied) {
    // The user has explicitly denied permission for media capture.
    NSLog(@"Denied");  //应该是这个，如果不允许的话
    [self PowerCamera:@"相机"];
    return NO;
  } else if (authStatus == AVAuthorizationStatusAuthorized) {  //允许访问
    // The user has explicitly granted permission for media capture, or explicit
    // user permission is not necessary for the media type in question.
    NSLog(@"Authorized");
    return YES;

  } else if (authStatus == AVAuthorizationStatusNotDetermined) {
    // Explicit user permission is required for media capture, but the user has
    // not yet granted or denied such permission.
    [AVCaptureDevice requestAccessForMediaType:mediaType
                             completionHandler:^(BOOL granted) {
                               if (granted) {  //点击允许访问时调用
                                 //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                                 NSLog(@"Granted access to %@", mediaType);
                                 [self PowerCamera:@"相机"];
                               } else {
                                 [self PowerCamera:@"相机"];
                                 NSLog(@"Not granted access to %@", mediaType);
                               }

                             }];
    return NO;
  } else {
    NSLog(@"Unknown authorization status");
    return NO;
  }
}

/**
 *  判断相册权限是否有开
 *
 *  @return yes 已授权 no 未授权
 */
- (BOOL)IsLibraryCanUse {
  ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
  if (author == kCLAuthorizationStatusRestricted ||
      author == kCLAuthorizationStatusDenied) {
    [self PowerCamera:@"相册"];
    return NO;
  } else
    return YES;
}

/**
 *  弹出提示框
 *
 *  @param msg 提示内容
 */
- (void)PowerCamera:(NSString *)msg {
  UIAlertView *alert =
      [[UIAlertView alloc]
              initWithTitle:@"提示"
                    message:[
                                [NSString alloc] initWithFormat:@"请"
                                                                @"在设备的设置"
                                                                @"-隐私-%@"
                                                                @"中允许访问%@"
                                                                @"。",
                                                                msg, msg]
                   delegate:self
          cancelButtonTitle:@"确定"
          otherButtonTitles:nil];
  [alert show];
}

/**
 *  选择图片后调用
 *
 *  @param picker 手机相机对象
 *  @param info   照相机相关信息
 */
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
  [picker dismissViewControllerAnimated:YES completion:nil];
  [self initAlertView];
  NSData *UploadImgData;
  UIImage *this_image;
    if (self->imagetype == 1) {
    this_image = [info objectForKey:UIImagePickerControllerOriginalImage];
    this_image = [self fixOrientation:this_image];
        
    UploadImgData =
        UIImageJPEGRepresentation(this_image, 0.1);  // 0.0001压缩倍数,1不压缩
  } else {
    this_image = [info objectForKey:UIImagePickerControllerEditedImage];
    this_image = [self fixOrientation:this_image];
      UploadImgData = UIImagePNGRepresentation(this_image);
    
  }
//  //拼接参数
//  NSDictionary *paramDictLeft = [NSDictionary
//      dictionaryWithObjectsAndKeys:[[NSString alloc]
//                                       initWithFormat:@"%f",
//                                                      this_image.size.height],
//                                   @"height",
//                                   [[NSString alloc]
//                                       initWithFormat:@"%f",
//                                                      this_image.size.width],
//                                   @"width", nil];
//
//  NSString *paramsLeft = [NSString createJSONStr:paramDictLeft];
//  NSDictionary *dictLeft = @{ @"parms" : paramsLeft };

  NSDictionary *dic = [NSDictionary
      dictionaryWithObjectsAndKeys:@"fileupload", @"func", @"", @"parms", nil];
  NSLog(@"%@", dic);
  NSString *myurl = [[NSString alloc] initWithFormat:@"%@", [AppConfig FileUpLoad]];
    NSLog(@"imgdata:%@",UploadImgData);
  [AFNTool
      ImagePostWithUrl:myurl
             AndParams:dic
          AndImageData:UploadImgData
             Comoplete:^(id responseObj, NSError *error) {
                 NSLog(@"错误:%@",error);
               if (error == nil) {
                   NSLog(@"www%@",responseObj);
                 NSDictionary *dictionary = [NSJSONSerialization
                     JSONObjectWithData:responseObj
                                options:NSJSONReadingMutableContainers
                                  error:nil];
                 NSString *filename = [dictionary valueForKey:@"txname"];
                 self.txname = filename;
                 NSLog(@"######%@", filename);
                 NSString *txjs = [[NSString alloc]
                     initWithFormat:@"updatetx(\"%@\")", self.txname];
                   NSLog(@"tpmc:%@",txjs);
                 [self runJavaScript:txjs];
                 [self.alert
                     dismissWithClickedButtonIndex:[self.alert
                                                           cancelButtonIndex]
                                          animated:YES];
               } else {
                 NSLog(@"error = %@", error);
               }
             }];
}

/**
 *  修改图片旋转角度问题
 *
 *  @param aImage 要修正的图片
 *
 *  @return 返回修正后图片
 */
- (UIImage *)fixOrientation:(UIImage *)aImage {
  if (aImage.imageOrientation == UIImageOrientationUp) return aImage;
  CGAffineTransform transform = CGAffineTransformIdentity;

  switch (aImage.imageOrientation) {
    case UIImageOrientationDown:
    case UIImageOrientationDownMirrored:
      transform = CGAffineTransformTranslate(transform, aImage.size.width,
                                             aImage.size.height);
      transform = CGAffineTransformRotate(transform, M_PI);
      break;

    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
      transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
      transform = CGAffineTransformRotate(transform, M_PI_2);
      break;

    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
      transform = CGAffineTransformRotate(transform, -M_PI_2);
      break;
    default:
      break;
  }

  switch (aImage.imageOrientation) {
    case UIImageOrientationUpMirrored:
    case UIImageOrientationDownMirrored:
      transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;

    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRightMirrored:
      transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;
    default:
      break;
  }

  CGContextRef ctx =
      CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,

                            CGImageGetBitsPerComponent(aImage.CGImage), 0,
                            CGImageGetColorSpace(aImage.CGImage),
                            CGImageGetBitmapInfo(aImage.CGImage));
  CGContextConcatCTM(ctx, transform);
  switch (aImage.imageOrientation) {
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      // Grr...
      CGContextDrawImage(
          ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width),
          aImage.CGImage);
      break;

    default:
      CGContextDrawImage(
          ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height),
          aImage.CGImage);
      break;
  }

  CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
  UIImage *img = [UIImage imageWithCGImage:cgimg];
  CGContextRelease(ctx);
  CGImageRelease(cgimg);
  return img;
}

#pragma mark - DoImagePickerControllerDelegate多选照片
- (void)didCancelDoImagePickerController {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:
            (DoImagePickerController *)picker
                                            result:(NSArray *)aSelected {
  [self dismissViewControllerAnimated:YES completion:nil];
  if (aSelected.count != 0) {
    [self initAlertView];
    int sl = 0;
    [self oneByOneUpPhotoWithPicker:picker result:aSelected sl:sl];
  }
}

/**
 *  循环上传照片
 */
- (void)oneByOneUpPhotoWithPicker:(DoImagePickerController *)picker
                           result:(NSArray *)aSelected
                               sl:(int)sl {
  if (aSelected.count < sl + 1) {
    [NSThread sleepForTimeInterval:1];
    [self.alert dismissWithClickedButtonIndex:[self.alert cancelButtonIndex]
                                     animated:YES];
  } else {
    [self UpDataPhotoWithImage:aSelected[sl]
                        Picker:picker
                        result:aSelected
                            sl:sl];
  } 
}

/**
 *  上传一张图片
 */
- (void)UpDataPhotoWithImage:(UIImage *)image
                      Picker:(DoImagePickerController *)picker
                      result:(NSArray *)aSelected
                          sl:(int)sl {
  NSData *UploadImgData =
      UIImageJPEGRepresentation(image, 1);  // 0.0001压缩倍数,1不压缩
  NSDictionary *dic = [NSDictionary
      dictionaryWithObjectsAndKeys:@"fileupload", @"func", @"", @"parms", nil];
  NSString *myurl = [[NSString alloc] initWithFormat:@"%@", [AppConfig FileUpLoad]];

  [AFNTool ImagePostWithUrl:myurl
                  AndParams:dic
               AndImageData:UploadImgData
                  Comoplete:^(id responseObj, NSError *error) {
                    if (error == nil) {
                      NSDictionary *dictionary = [NSJSONSerialization
                          JSONObjectWithData:responseObj
                                     options:NSJSONReadingMutableContainers
                                       error:nil];
                      NSString *filename = [dictionary valueForKey:@"txname"];
                      self.txname = filename;
                      NSLog(@"######------%@", filename);
                      NSString *txjs = [[NSString alloc]
                          initWithFormat:@"updatetx(\"%@\")", self.txname];
                      [self runJavaScript:txjs];
                      [self oneByOneUpPhotoWithPicker:picker
                                               result:aSelected
                                                   sl:(sl + 1)];
                    } else {
                      NSLog(@"error = %@", error);
                      [self oneByOneUpPhotoWithPicker:picker
                                               result:aSelected
                                                   sl:(sl + 1)];
                    }
                  }];
}

#pragma mark - 图片下载
- (UIImage *)getImageFromURL:(NSString *)fileURL {
  [self initDownloadView];
  //    NSLog(@"执行图片下载函数");
  UIImage *result;

  NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
  result = [UIImage imageWithData:data];
  return result;
}

- (void)image:(UIImage *)image
    didFinishSavingWithError:(NSError *)error
                 contextInfo:(void *)contextInfo {
  NSString *msg = nil;
  if (error != NULL) {
    msg = @"保存图片失败";
  } else {
    msg = @"已保存到系统相册";
  }
  [NSThread sleepForTimeInterval:1];

  [self.alert dismissWithClickedButtonIndex:[self.alert cancelButtonIndex]
                                   animated:YES];
  UIAlertView *savealert = [[UIAlertView alloc] initWithTitle:nil
                                                      message:msg
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
  [savealert show];
}

/**
 *  加载下载图片等待提示框
 */
- (void)initDownloadView {
  [self initActivity];
  self.alert = [[UIAlertView alloc] initWithTitle:nil
                                          message:@"正在下载，请稍后..."
                                         delegate:self
                                cancelButtonTitle:nil
                                otherButtonTitles:nil];
  [self.alert setValue:self.activityIndicator forKey:@"accessoryView"];
  self.alert.tag = 104;
  [self.alert show];
}

/**
 *  加载上传等待提示框
 */
- (void)initAlertView {
  [self initActivity];
  self.alert = [[UIAlertView alloc] initWithTitle:@"正在上传，请稍后..."
                                          message:nil
                                         delegate:self
                                cancelButtonTitle:nil
                                otherButtonTitles:nil];
  [self.alert setValue:self.activityIndicator forKey:@"accessoryView"];
  self.alert.tag = 101;
  [self.alert show];
}

/**
 *  加载风火轮
 */
- (void)initActivity {
  //初始化:
  self.activityIndicator =
      [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];

  self.activityIndicator.tag = 103;

  //设置显示样式,见UIActivityIndicatorViewStyle的定义
  self.activityIndicator.activityIndicatorViewStyle =
      UIActivityIndicatorViewStyleGray;

  //设置背景色
  self.activityIndicator.backgroundColor = [UIColor clearColor];

  //设置背景为圆角矩形
  self.activityIndicator.layer.cornerRadius = 6;
  self.activityIndicator.layer.masksToBounds = YES;
  //设置显示位置
  [self.activityIndicator
      setCenter:CGPointMake(self.view.frame.size.width / 2.0,
                            self.view.frame.size.height / 2.0)];

  //开始显示Loading动画
  [self.activityIndicator startAnimating];
}

@end
