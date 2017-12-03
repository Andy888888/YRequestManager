//
//  InterceptorForRespFail.m
//  APlus
//
//  Created by 燕文强 on 2017/9/24.
//  Copyright © 2017年 燕文强. All rights reserved.
//

#import "InterceptorForRespFail.h"

@implementation InterceptorForRespFail

- (CentaResponse *)intercept:(id)task andRespData:(NSError *)respData andApi:(AbsApi<ApiDelegate>*)api
{
    CentaResponse *resp = [self createResponse];
    resp.api = (BaseApi *)api;
    
    NSURLSessionDataTask *urlTask = task;
    NSHTTPURLResponse *urlresp = (NSHTTPURLResponse *)urlTask.response;
    resp.code = urlresp.statusCode;
    
    return resp;
}

- (CentaResponse *)createResponse
{
    CentaResponse *resp = [CentaResponse new];
    resp.suc = NO;
    resp.code = 200;
    resp.msg = @"";
    
    return resp;
}

@end
