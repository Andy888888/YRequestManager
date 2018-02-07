//
//  ReqLogInterceptor.m
//  APlus
//
//  Created by 燕文强 on 2017/9/22.
//  Copyright © 2017年 燕文强. All rights reserved.
//

#import "ReqLogInterceptor.h"

@implementation ReqLogInterceptor

- (CentaResponse *)intercept:(AbsApi<ApiDelegate> *)api
{
    NSString *requestUrl = [api getReqUrl];
    NSDictionary *bodyDic = [api getReqBody];
    NSLog(@"********[请求地址：%@]",requestUrl);
    NSLog(@"********[请求参数：%@]",bodyDic);
    
#warning 若是拦截，请将resp.suc置为NO
//    CentaResponse *resp = [super intercept:api];
//    resp.msg = @"没理由，就是不想让你请求！";
//    resp.suc = NO;
//    return resp;
    
    return [super intercept:api];
}

@end
