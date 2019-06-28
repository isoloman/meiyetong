//
//  AFNTool.h
//  SportShell
//
//  Created by Toprank on 16/6/24.
//  Copyright © 2016年 SportShell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFNTool : NSObject

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)SendGetWithUrl:(NSString *)url AndParams:(NSDictionary *)params Success:(void (^)(id responseObj))success Failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)SendPostWithUrl:(NSString *)url AndParams:(NSDictionary *)params Success:(void (^)(id responseObj))success Failure:(void (^)(NSError *error))failure;


/**
 *  发送一个POST上传图片请求
 *
 *  @param url   请求路径
 *  @param params 请求参数
 *  @param image 图片
 *  @param block 上传结束的回调
 */
+ (void)ImagePostWithUrl:(NSString *)url AndParams:(NSDictionary *)params AndImageData:(NSData*)image Comoplete:(void(^)(id responseObj,NSError *error))block;

@end
