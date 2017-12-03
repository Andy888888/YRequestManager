//
//  RequestManager.m
//  AF_RequestManager
//
//  Created by 燕文强 on 16/7/27.
//  Copyright © 2016年 燕文强. All rights reserved.
//

#import "RequestManager.h"
#import "ReqLogInterceptor.h"
#import "NetworkProtocalInterceptor.h"
#import "RespSucInterceptor.h"


@implementation RequestManager

+ (id)defaultManager:(id<ResponseDelegate>)delegate
{
    RequestManager *manager = [RequestManager initManagerWithDelegate:delegate];
    [manager addIntercepterForReq:[[ReqLogInterceptor alloc] init]];
    [manager setInterceptorForSuc:[[RespSucInterceptor alloc]init]];
    [manager addIntercepterForRespFail:[[NetworkProtocalInterceptor alloc]init]];
    
    return manager;
}

+ (id)initManagerWithDelegate:(id<ResponseDelegate>)delegate
{
    RequestManager *manager = [[RequestManager alloc]init];
    manager.delegate = delegate;
    return manager;
}

- (void)sendRequest:(AbsApi<ApiDelegate>*)api
{
    int requestMethod = [api getRequestMethod];
    if(requestMethod == RequestMethodPOST)
    {
        [self postRequest:api];
    }
    else
    {
        [self getRequest:api];
    }
}


- (void)postRequest:(AbsApi<ApiDelegate>*)api
{
    NSString *requestUrl = [api getReqUrl];
    NSDictionary *bodyDic = [api getReqBody];
    
    BOOL intercepterReq = NO;
    for (InterceptorForReq *item in self.interceptorsForReq)
    {
        CentaResponse *resp = [item intercept:api];
        BOOL valid = resp.suc;
        if(!valid)
        {
            intercepterReq = YES;
            [self.delegate respFail:resp];
            break;
        }
    }
    if(intercepterReq)
    {
        return;
    }
    
    AFHTTPSessionManager *manager = [self createAFHttpManagerForApi:api];
    
    [manager POST:requestUrl
       parameters:bodyDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             NSLog(@"%@",uploadProgress);
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             // 请求成功
             if (self.delegate)
             {
                 [self.delegate respSuc:[self.interceptorForSuc intercept:task andRespData:responseObject andApi:api]];
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             // 请求失败
             BOOL intercept = NO;
             for (InterceptorForRespFail *item in self.interceptorsForResp) {
                 CentaResponse *resp = [item intercept:task andRespData:error andApi:api];
                 BOOL valid = resp.suc;
                 if(!valid)
                 {
                     intercept = YES;
                     [self.delegate respFail:resp];
                     break;
                 }
             }
             
             if(intercept){
                 return;
             }
             
             if (self.delegate)
             {
                 [self.delegate respFail:[self error2CentaResponse:error andApi:api]];
             }
         }];
}

- (void)getRequest:(AbsApi<ApiDelegate>*)api
{
    NSString *requestUrl = [self getReqGetUrl:api];
    
    BOOL intercepterReq = NO;
    for (InterceptorForReq *item in self.interceptorsForReq) {
        CentaResponse *resp = [item intercept:api];
        BOOL valid = resp.suc;
        if(!valid)
        {
            intercepterReq = YES;
            [self.delegate respFail:resp];
            break;
        }
    }
    if(intercepterReq){
        return;
    }
    
    AFHTTPSessionManager *manager = [self createAFHttpManagerForApi:api];
    [manager GET:requestUrl
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功
            if (self.delegate)
            {
                [self.delegate respSuc:[self.interceptorForSuc intercept:task andRespData:responseObject andApi:api]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            BOOL intercept = NO;
            for (InterceptorForRespFail *item in self.interceptorsForResp) {
                CentaResponse *resp = [item intercept:task andRespData:error andApi:api];
                BOOL valid = resp.suc;
                if(!valid)
                {
                    intercept = YES;
                    [self.delegate respFail:resp];
                    break;
                }
            }
            
            if(intercept){
                return;
            }
            
            if (self.delegate)
            {
                [self.delegate respFail:[self error2CentaResponse:error andApi:api]];
            }
        }];
}

@end
