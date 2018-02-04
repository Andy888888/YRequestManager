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
#import "NSDictionary+JSONTransfer.h"

@implementation RequestManager

+ (id)defaultManager:(id<YResponseDelegate>)delegate
{
    RequestManager *manager = [RequestManager initManagerWithYDelegate:delegate];
    [manager addIntercepterForReq:[[ReqLogInterceptor alloc] init]];
    [manager setInterceptorForSuc:[[RespSucInterceptor alloc]init]];
    [manager addIntercepterForRespFail:[[NetworkProtocalInterceptor alloc]init]];
    
    return manager;
}

// ----------------- Version 1.0.0 -----------------
+ (id)initManagerWithDelegate:(id<ResponseDelegate>)delegate
{
    RequestManager *manager = [[RequestManager alloc]init];
    manager.delegate = delegate;
    return manager;
}
// ----------------- Version 1.0.0 -----------------

+ (id)initManagerWithYDelegate:(id<YResponseDelegate>)delegate
{
    RequestManager *manager = [[RequestManager alloc]init];
    manager.ydelegate = delegate;
    return manager;
}

// ----------------- Version 1.0.0 -----------------
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
// ----------------- Version 1.0.0 -----------------

- (void)request:(AbsApi<ApiDelegate>*)api
{
    int requestMethod = [api getRequestMethod];
    if(requestMethod == RequestMethodPOST)
    {
        [self requestPOST:api];
    }
    else
    {
        [self requestGET:api];
    }
}

// ----------------- Version 1.0.0 -----------------
- (void)postRequest:(AbsApi<ApiDelegate>*)api
{
    NSString *requestUrl = [api getReqUrl];
    NSDictionary *bodyDic = [api getReqBody];
    Class cls = [api getRespClass];
    
    NSLog(@"********[请求地址：%@]",requestUrl);
    NSLog(@"********[请求参数：%@]",[bodyDic JSONString]);
    
    AFHTTPSessionManager *manager = [self createAFHttpManagerForApi:api];
    
    [manager POST:requestUrl
       parameters:bodyDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             NSLog(@"%@",uploadProgress);
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             //请求成功
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
             
             NSLog(@"********[返回参数：%@]",dic);
             
             if (self.delegate) {
                 [self.delegate respSuc:dic andRespClass:cls];
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             //请求失败
             NSHTTPURLResponse *urlResp = (NSHTTPURLResponse *)task.response;
             NSError *newError = [NSError errorWithDomain:error.domain code:urlResp.statusCode userInfo:error.userInfo];
             
             if (self.delegate) {
                 [self.delegate respFail:newError andRespClass:cls];
             }
         }];
}

- (void)getRequest:(AbsApi<ApiDelegate>*)api
{
    NSString *requestUrl = [self getReqGetUrl:api];
    Class cls = [api getRespClass];
    NSLog(@"********[请求地址：%@]",requestUrl);
    
    AFHTTPSessionManager *manager = [self createAFHttpManagerForApi:api];
    [manager GET:requestUrl
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //请求成功
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                options:NSJSONReadingAllowFragments
                                                                  error:nil];
            if (self.delegate) {
                [self.delegate respSuc:dic andRespClass:cls];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //请求失败
            if (self.delegate) {
                [self.delegate respFail:error andRespClass:cls];
            }
        }];
}
// ----------------- Version 1.0.0 -----------------

- (void)requestPOST:(AbsApi<ApiDelegate>*)api
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
            [self.ydelegate respFail:resp];
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
             if (self.ydelegate)
             {
                 [self.ydelegate respSuc:[self.interceptorForSuc intercept:task andRespData:responseObject andApi:api]];
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
                     [self.ydelegate respFail:resp];
                     break;
                 }
             }
             
             if(intercept){
                 return;
             }
             
             if (self.ydelegate)
             {
                 [self.ydelegate respFail:[self error2CentaResponse:error andApi:api]];
             }
         }];
}

- (void)requestGET:(AbsApi<ApiDelegate>*)api
{
    NSString *requestUrl = [self getReqGetUrl:api];
    
    BOOL intercepterReq = NO;
    for (InterceptorForReq *item in self.interceptorsForReq) {
        CentaResponse *resp = [item intercept:api];
        BOOL valid = resp.suc;
        if(!valid)
        {
            intercepterReq = YES;
            [self.ydelegate respFail:resp];
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
            if (self.ydelegate)
            {
                [self.ydelegate respSuc:[self.interceptorForSuc intercept:task andRespData:responseObject andApi:api]];
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
                    [self.ydelegate respFail:resp];
                    break;
                }
            }
            
            if(intercept){
                return;
            }
            
            if (self.ydelegate)
            {
                [self.ydelegate respFail:[self error2CentaResponse:error andApi:api]];
            }
        }];
}

@end
