//
//  InterceptorForReq.m
//  APlus
//
//  Created by 燕文强 on 2017/9/20.
//  Copyright © 2017年 燕文强. All rights reserved.
//

#import "InterceptorForReq.h"

@implementation InterceptorForReq

- (CentaResponse *)intercept:(AbsApi<ApiDelegate>*)api
{
    CentaResponse *resp = [self createResponse];
    resp.api = (BaseApi *)api;
    return resp;
}

- (CentaResponse *)createResponse
{
    CentaResponse *resp = [CentaResponse new];
    resp.suc = YES;
    resp.code = 999;// 自定义的code，为请求中拦截掉的
    resp.msg = @"";
    //  作为兄弟当然不想让你挨骂，但我更不想看到你
    return resp;
}

@end
