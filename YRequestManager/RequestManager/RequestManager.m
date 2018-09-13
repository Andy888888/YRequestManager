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
#import "NSDictionary+Json.h"

@implementation RequestManager

+ (id)defaultManager:(id<ResponseDelegate>)delegate {
    
    RequestManager *manager = [RequestManager initManagerWithDelegate:delegate withNewVersion:YES];
    [manager addIntercepterForReq:[[ReqLogInterceptor alloc] init]];
    [manager setInterceptorForSuc:[[RespSucInterceptor alloc]init]];
    [manager addIntercepterForRespFail:[[NetworkProtocalInterceptor alloc]init]];
    
    return manager;
}


+ (id)initManagerWithDelegate:(id<ResponseDelegate>)delegate {
    
    return  [self initManagerWithDelegate:delegate withNewVersion:NO];
}


+ (id)initManagerWithDelegate:(id<ResponseDelegate>)delegate withInterceptor:(BOOL)Interceptor {
    
    if (Interceptor) {
        
     return [self defaultManager:delegate];
        
    }else{
        
     return [self initManagerWithDelegate:delegate];
        
    }
    
}
 
+ (id)initManagerWithDelegate:(id<ResponseDelegate>)delegate withNewVersion:(BOOL)newVersion {
    
    // 从父类初始化 返回当前类的对象
    RequestManager *manager = [super initManager];
    manager.delegate = delegate;
    
    if (newVersion) {
        
        NSAssert(([manager.delegate respondsToSelector:@selector(respSuc:)] && [manager.delegate respondsToSelector:@selector(respFail:)]), @"使用新版本 必须实现 - (void)respSuc:(CentaResponse *)resData 以及 - (void)respFail:(CentaResponse *)error方法");

    }else{
        
        NSAssert(([manager.delegate respondsToSelector:@selector(respSuc:andRespClass:)] && [manager.delegate respondsToSelector:@selector(respFail:andRespClass:)]), @"使用旧版本 必须实现- (void)respSuc:(id)data andRespClass - (void)respFail:(NSError *)error andRespClass:(id)cls:(id)cls 方法");
        
    }
    
    return manager;
}
- (void)sendRequest:(AbsApi<ApiDelegate>*)api {
    
    [super sendRequest:api sucBlock:nil failBlock:nil];
}

//// ----------------- Version 1.0.0 -----------------
//+ (id)initManagerWithDelegate:(id<ResponseDelegate>)delegate
//{
//    RequestManager *manager = [[RequestManager alloc]init];
//    manager.delegate = delegate;
//    return manager;
//}


// ----------------- Version 1.5.0 -----------------

//+ (id)initManagerWithYDelegate:(id<YResponseDelegate>)delegate
//{
//    RequestManager *manager = [[RequestManager alloc]init];
//    manager.ydelegate = delegate;
//    return manager;
//}


//- (void)sendRequest:(AbsApi<ApiDelegate>*)api
//{
//    int requestMethod = [api getRequestMethod];
//    if(requestMethod == RequestMethodPOST)
//    {
//        [self postRequest:api];
//        return;
//    }
//    if(requestMethod == RequestMethodGET)
//    {
//        [self getRequest:api];
//        return;
//    }
//    if(requestMethod == RequestMethodPUT)
//    {
//        [self putRequest:api];
//        return;
//    }
//    if(requestMethod == RequestMethodDELETE)
//    {
//        [self deleteRequest:api];
//        return;
//    }
//}
//// ----------------- Version 1.0.0 -----------------
//
//- (void)request:(AbsApi<ApiDelegate>*)api
//{
//    int requestMethod = [api getRequestMethod];
//    if(requestMethod == RequestMethodPOST)
//    {
//        [self requestPOST:api];
//        return;
//    }
//    if(requestMethod == RequestMethodGET)
//    {
//        [self requestGET:api];
//        return;
//    }
//    if(requestMethod == RequestMethodPUT)
//    {
//        [self requestPUT:api];
//        return;
//    }
//    if(requestMethod == RequestMethodDELETE)
//    {
//        [self requestDELETE:api];
//        return;
//    }
//}

//#pragma mark - Version 1.0.0
//// ----------------- Version 1.0.0 -----------------
//- (void)postRequest:(AbsApi<ApiDelegate>*)api
//{
//    NSString *requestUrl = [api getReqUrl];
//    NSDictionary *bodyDic = [api getReqBody];
//    Class cls = [api getRespClass];
//
//    AFHTTPSessionManager *manager = [self createAFHttpManagerForApi:api];
//
//    [manager POST:requestUrl
//       parameters:bodyDic
//         progress:^(NSProgress * _Nonnull uploadProgress) {
//         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//             if (self.delegate) {
//                 [self.delegate respSuc:responseObject andRespClass:cls];
//             }
//
//         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//             //请求失败
//             NSHTTPURLResponse *urlResp = (NSHTTPURLResponse *)task.response;
//             NSError *newError = [NSError errorWithDomain:error.domain code:urlResp.statusCode userInfo:error.userInfo];
//
//             if (self.delegate) {
//                 [self.delegate respFail:newError andRespClass:cls];
//             }
//         }];
//}
//
//- (void)getRequest:(AbsApi<ApiDelegate>*)api
//{
//    NSString *requestUrl = [api getReqUrl];
////    NSString *requestUrl = [self getReqGetUrl:api];
//    Class cls = [api getRespClass];
//
//    AFHTTPSessionManager *manager = [self createAFHttpManagerForApi:api];
//    [manager GET:requestUrl
//      parameters:[api getBody]
//        progress:^(NSProgress * _Nonnull downloadProgress) {
//
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            if (self.delegate) {
//                [self.delegate respSuc:responseObject andRespClass:cls];
//            }
//
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            //请求失败
//            if (self.delegate) {
//                [self.delegate respFail:error andRespClass:cls];
//            }
//        }];
//}
//
//- (void)putRequest:(AbsApi<ApiDelegate>*)api
//{
//    NSString *requestUrl = [api getReqUrl];
//    NSDictionary *bodyDic = [api getReqBody];
//    Class cls = [api getRespClass];
//
//    AFHTTPSessionManager *manager = [self createAFHttpManagerForApi:api];
//
//    [manager PUT:requestUrl
//       parameters:bodyDic
//         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//             if (self.delegate) {
//                 [self.delegate respSuc:responseObject andRespClass:cls];
//             }
//
//         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//             //请求失败
//             NSHTTPURLResponse *urlResp = (NSHTTPURLResponse *)task.response;
//             NSError *newError = [NSError errorWithDomain:error.domain code:urlResp.statusCode userInfo:error.userInfo];
//
//             if (self.delegate) {
//                 [self.delegate respFail:newError andRespClass:cls];
//             }
//         }];
//}
//
//- (void)deleteRequest:(AbsApi<ApiDelegate>*)api
//{
//    NSString *requestUrl = [api getReqUrl];
//    NSDictionary *bodyDic = [api getReqBody];
//    Class cls = [api getRespClass];
//
//    AFHTTPSessionManager *manager = [self createAFHttpManagerForApi:api];
//
//    [manager DELETE:requestUrl
//      parameters:bodyDic
//         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//             if (self.delegate) {
//                 [self.delegate respSuc:responseObject andRespClass:cls];
//             }
//
//         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//             //请求失败
//             NSHTTPURLResponse *urlResp = (NSHTTPURLResponse *)task.response;
//             NSError *newError = [NSError errorWithDomain:error.domain code:urlResp.statusCode userInfo:error.userInfo];
//
//             if (self.delegate) {
//                 [self.delegate respFail:newError andRespClass:cls];
//             }
//         }];
//}
//
//// ----------------- Version 1.0.0 -----------------
//
//#pragma mark - Version 1.0.5
//- (void)requestPOST:(AbsApi<ApiDelegate>*)api
//{
//    CentaResponse *reqResp = [self checkReqInterceptor:api];
//    if(nil != reqResp){
//        [self.ydelegate respFail:reqResp];
//        return;
//    }
//
//    NSString *requestUrl = [api getReqUrl];
//    NSDictionary *bodyDic = [api getReqBody];
//
//    AFHTTPSessionManager *manager = [self createAFHttpManagerForApi:api];
//    [manager POST:requestUrl
//       parameters:bodyDic
//         progress:^(NSProgress * _Nonnull uploadProgress) {
//
//         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//             // 请求成功
//             [self sucFunction:api task:task respData:responseObject];
//         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//             // 请求失败
//             [self failFunction:api task:task error:error];
//         }];
//}
//
//- (void)requestGET:(AbsApi<ApiDelegate>*)api
//{
//    CentaResponse *reqResp = [self checkReqInterceptor:api];
//    if(nil != reqResp){
//        [self.ydelegate respFail:reqResp];
//        return;
//    }
//
//    NSString *requestUrl = [api getReqUrl];
////    NSString *requestUrl = [self getReqGetUrl:api];
//
//    AFHTTPSessionManager *manager = [self createAFHttpManagerForApi:api];
//    [manager GET:requestUrl
//      parameters:[api getBody]
//        progress:^(NSProgress * _Nonnull downloadProgress) {
//
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            // 请求成功
//            [self sucFunction:api task:task respData:responseObject];
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            // 请求失败
//            [self failFunction:api task:task error:error];
//        }];
//}
//
//- (void)requestPUT:(AbsApi<ApiDelegate>*)api
//{
//    CentaResponse *reqResp = [self checkReqInterceptor:api];
//    if(nil != reqResp){
//        [self.ydelegate respFail:reqResp];
//        return;
//    }
//
//    NSString *requestUrl = [api getReqUrl];
//    NSDictionary *bodyDic = [api getReqBody];
//
//    AFHTTPSessionManager *manager = [self createAFHttpManagerForApi:api];
//    [manager PUT:requestUrl
//      parameters:bodyDic
//         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//             // 请求成功
//             [self sucFunction:api task:task respData:responseObject];
//         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//             // 请求失败
//             [self failFunction:api task:task error:error];
//         }];
//}
//
//- (void)requestDELETE:(AbsApi<ApiDelegate>*)api
//{
//    CentaResponse *reqResp = [self checkReqInterceptor:api];
//    if(nil != reqResp){
//        [self.ydelegate respFail:reqResp];
//        return;
//    }
//
//    NSString *requestUrl = [api getReqUrl];
//    NSDictionary *bodyDic = [api getReqBody];
//
//    AFHTTPSessionManager *manager = [self createAFHttpManagerForApi:api];
//    [manager DELETE:requestUrl
//         parameters:bodyDic
//            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                // 请求成功
//                [self sucFunction:api task:task respData:responseObject];
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                // 请求失败
//                [self failFunction:api task:task error:error];
//            }];
//}
//
//#pragma mark - 私有方法
//// 请求成功
//- (void)sucFunction:(AbsApi<ApiDelegate> *)api task:(id)task respData:(id)respData
//{
//    if (self.ydelegate)
//    {
//        [self.ydelegate respSuc:[self.interceptorForSuc intercept:task andRespData:respData andApi:api]];
//    }
//}
//
//// 请求失败
//- (void)failFunction:(AbsApi<ApiDelegate> *)api task:(id)task error:(id)error
//{
//    CentaResponse *respResp = [self checkRespInterceptor:api task:task error:error];
//    if(nil != respResp){
//        [self.ydelegate respFail:respResp];
//        return;
//    }
//
//    if (self.ydelegate) {
//        [self.ydelegate respFail:[self error2CentaResponse:error andApi:api]];
//    }
//}

@end
