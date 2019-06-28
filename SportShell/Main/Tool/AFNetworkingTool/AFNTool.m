//
//  AFNTool.m
//  SportShell
//
//  Created by Toprank on 16/6/24.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import "AFNTool.h"
#import "AFNetworking.h"
#import "UIImage+AFNetworking.h"

@implementation AFNTool


+ (void)SendGetWithUrl:(NSString *)url AndParams:(NSDictionary *)params Success:(void (^)(id responseObj))success Failure:(void (^)(NSError *error))failure
{
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置超时的秒数
    //    manager.requestSerializer.timeoutInterval = 20;
    //设置响应数据为二进制
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置请求参数传输为二进制
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
    
    //发送GET请求
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"get请求成功。");
        if (success) {
            success(responseObject);
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"get请求失败。");
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)SendPostWithUrl:(NSString *)url AndParams:(NSDictionary *)params Success:(void (^)(id responseObj))success Failure:(void (^)(NSError *error))failure
{
    NSLog(@"-------------------------");
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置超时的秒数
    //    manager.requestSerializer.timeoutInterval = 20;
    //设置响应数据为二进制
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置请求参数传输为二进制
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
    
    // 发送POST请求
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"post请求成功。");
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"post请求失败。");
        if (failure) {
            failure(error);
        }
    }];
}
- (void) imageUpload:(UIImage *) image{
    //把图片转换成imageDate格式
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    //传送路径
    NSString *urlString = @"http://＊＊＊＊＊/test/upload.php";
    //建立请求对象
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    //设置请求路径
    [request setURL:[NSURL URLWithString:urlString]];
    //请求方式
    [request setHTTPMethod:@"POST"];
    //一连串上传头标签
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"vim_go.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    //上传文件开始
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //获得返回值
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",returnString);
}
+(void)ImagePostWithUrl:(NSString *)url AndParams:(NSDictionary *)params AndImageData:(NSData *)image Comoplete:(void (^)(id, NSError *))block
{
    NSLog(@"%@",url);
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置响应数据为二进制
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //发送请求
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 上传文件
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        [formData appendPartWithFileData:image name:@"upfile" fileName:fileName mimeType:@"image/png"];
        
    }progress:^(NSProgress * _Nonnull uploadProgress) {
        //这里可以获取到目前的数据请求的进度
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject,nil);
        NSLog(@"--------------上传成功------------------:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,error);
        NSLog(@"上传错误");
    }];
}

@end
