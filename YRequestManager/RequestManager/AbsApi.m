//
//  AbsApi.m
//  AF_RequestManager
//
//  Created by 燕文强 on 16/7/27.
//  Copyright © 2016年 燕文强. All rights reserved.
//

#import "AbsApi.h"

@implementation AbsApi

#pragma mark - 实现方法
- (NSString *)getRootUrl
{
    return nil;
}
- (NSString *)getPath
{
    return nil;
}

- (NSMutableDictionary *)getBaseHeader
{
    return nil;
}
- (NSDictionary *)getHeader
{
    return nil;
}

- (NSMutableDictionary *)getBaseBody
{
    return [NSMutableDictionary dictionary];
}
- (NSDictionary *)getBody
{
    return nil;
}

- (Class)getRespClass
{
    return  nil;
}

- (BOOL)isUrlEncode
{
    return NO;
}

- (BOOL)logEnable{
    return YES;
}

@end
