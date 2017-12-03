//
//  BaseApi.m
//  AF_RequestManager
//
//  Created by 燕文强 on 16/7/27.
//  Copyright © 2016年 燕文强. All rights reserved.
//

#import "BaseApi.h"

@implementation BaseApi

#pragma mark - ApiDelegate 重写

/// 请求url
/// @warning 默认url为nil
- (NSString *)getReqUrl
{
    NSString *reqUrl = [NSString stringWithFormat:@"%@%@",[self getRootUrl],[self getPath]];
    return reqUrl;
}

/// 请求header
/// @warning 默认header为nil
- (NSDictionary *)getReqHeader
{
    NSMutableDictionary *reqHeader = [self getBaseHeader];
    [reqHeader addEntriesFromDictionary:[self getHeader]];
    return reqHeader;
}

/// 请求body
/// @warning 默认body为nil
- (NSDictionary *)getReqBody
{
    NSMutableDictionary *reqBody = [self getBaseBody];
    [reqBody addEntriesFromDictionary:[self getBody]];
    return reqBody;
}

/// 请求方式
/// @warning 默认方式为Post（RequestMethodPOST）
- (int)getRequestMethod
{
    return RequestMethodPOST;
}

/// 请求超时时间
/// @warning 默认超时时间为5秒
- (int)getTimeOut
{
    return 5;
}

- (Class)getRespClass
{
    return nil;
}

- (NSString *)checkRespData:(id)data
{
    return nil;
}

@end
