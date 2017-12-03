//
//  BaseApi.h
//  AF_RequestManager
//
//  Created by 燕文强 on 16/7/27.
//  Copyright © 2016年 燕文强. All rights reserved.
//

#import "ApiDelegate.h"
#import "AbsApi.h"

#define Default_Msg @"操作不成功!"

/// BaseApi 请求基类，继承自AbsApi，且遵守了ApiDelegate协议
/// @warning 请不要随便修改
@interface BaseApi : AbsApi<ApiDelegate>

/// 返回值只要不是nil，任何值都被认为有错误信息
- (NSString *)checkRespData:(id)data;

@end
