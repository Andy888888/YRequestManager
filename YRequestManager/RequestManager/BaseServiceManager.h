//
//  BaseServiceManager.h
//  AF_RequestManager
//
//  Created by 燕文强 on 16/7/26.
//  Copyright © 2016年 燕文强. All rights reserved.
//

#import "ApiDelegate.h"
#import "AbsApi.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "InterceptorForReq.h"
#import "InterceptorForRespSuc.h"
#import "InterceptorForRespFail.h"

// ----------------- Version 1.0.0 -----------------
/// 请求响应成功的block
typedef void (^ResponseSuccessBlock)(id result);
/// 请求响应失败的block
typedef void (^ResponseFailureBlock)(NSError *error);
// ----------------- Version 1.0.0 -----------------

/// 请求响应成功的block
typedef void (^RespSucBlock)(CentaResponse *result);
/// 请求响应失败的block
typedef void (^RespFailBlock)(CentaResponse *error);

/// BaseServiceManager 用来使用AFNetWorking发送请求，只是个管理者，本身并不具备发送请求能力；
/// @warning 设计此Manager主要目的是，后期不采用AFNetWorking时，可在本类的发送方法sendRequest...中切换其他第三方请求框架即可，而不需要项目中到处修改AFNetWorking请求为其他方式请求，同时担任着控制第三方请求的角色；因此，即使不习惯本类，也不要修改；另外，本类只拥有block回调方式请求
/// @warning 请不要随便修改
@interface BaseServiceManager : NSObject
@property (nonatomic,strong) AFHTTPSessionManager *manager;
+ (id)initManager;

/// 拦截器，里面规范了返回数据的正确与否
@property (nonatomic,strong) NSMutableArray *interceptorsForReq;
@property (nonatomic,strong) NSMutableArray *interceptorsForResp;
@property (nonatomic,strong) InterceptorForRespSuc *interceptorForSuc;

// ----------------- Version 1.0.0 -----------------
/// 1.0.0版本请求方式
- (void)sendRequest:(AbsApi<ApiDelegate>*)api
           sucBlock:(ResponseSuccessBlock)sucBlock
          failBlock:(ResponseFailureBlock)failBlock;
// ----------------- Version 1.0.0 -----------------

/// 使用block方式发送数据请求；api：发送参数，sucBlock：成功回调，failBlock：失败回调
- (void)request:(AbsApi<ApiDelegate>*)api
       sucBlock:(RespSucBlock)sucBlock
      failBlock:(RespFailBlock)failBlock;

- (AFHTTPSessionManager *)createAFHttpManagerForApi:(AbsApi<ApiDelegate>*)api;
- (NSString *)getReqGetUrl:(AbsApi<ApiDelegate>*)api;
- (void)addIntercepterForReq:(InterceptorForReq *)interceptor;
- (void)addIntercepterForRespFail:(InterceptorForRespFail *)interceptor;
- (CentaResponse *)error2CentaResponse:(NSError *)error
                                andApi:(AbsApi<ApiDelegate>*)api;
- (CentaResponse *)checkReqInterceptor:(AbsApi<ApiDelegate>*)api;
- (CentaResponse *)checkRespInterceptor:(AbsApi<ApiDelegate>*)api
                                   task:(NSURLSessionDataTask * _Nullable)task
                                  error:(NSError * _Nonnull)error;

@end
