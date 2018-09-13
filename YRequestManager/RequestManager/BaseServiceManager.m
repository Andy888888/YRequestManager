//
//  BaseServiceManager.m
//  AF_RequestManager
//
//  Created by 燕文强 on 16/7/26.
//  Copyright © 2016年 燕文强. All rights reserved.
//

#import "BaseServiceManager.h"
#import "NSDictionary+Json.h"
@interface BaseServiceManager()
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,assign) BOOL newVersion;
@end


@implementation BaseServiceManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.interceptorsForReq = [[NSMutableArray alloc]init];
        self.interceptorsForResp = [[NSMutableArray alloc]init];

    }
    return self;
}

- (instancetype)initWithNewVersion:(BOOL)newVerion {
    
    if (self = [self init]) {
        
        self.newVersion = newVerion;
    }
    return self;
}

+ (id)initManager
{
    
    return [self initManagerWithNewVersion:NO];
}

+ (id)initManagerWithNewVersion:(BOOL)newVersion {
    static BaseServiceManager *baseManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        baseManager = [[self alloc] initWithNewVersion:newVersion];
        
    });
    return baseManager;
}

// ----------------- Version 1.0.0 -----------------
- (void)sendRequest:(AbsApi<ApiDelegate>*)api
           sucBlock:(ResponseSuccessBlock)sucBlock
          failBlock:(ResponseFailureBlock)failBlock;
{
    int requestMethod = [api getRequestMethod];
    if(requestMethod == RequestMethodPOST){
        [self postRequest:api sucBlock:sucBlock failBlock:failBlock];
        return;
    }
    if(requestMethod == RequestMethodGET)
    {
        [self getRequest:api sucBlock:sucBlock failBlock:failBlock];
        return;
    }
    if(requestMethod == RequestMethodPUT)
    {
        [self putRequest:api sucBlock:sucBlock failBlock:failBlock];
        return;
    }
    if(requestMethod == RequestMethodDELETE)
    {
        [self deleteRequest:api sucBlock:sucBlock failBlock:failBlock];
        return;
    }
}


//- (void)request:(AbsApi<ApiDelegate>*)api
//       sucBlock:(RespSucBlock)sucBlock
//      failBlock:(RespFailBlock)failBlock;
//{
//    int requestMethod = [api getRequestMethod];
//    if(requestMethod == RequestMethodPOST){
//        [self requestPOST:api sucBlock:sucBlock failBlock:failBlock];
//        return;
//    }
//    if(requestMethod == RequestMethodGET)
//    {
//        [self requestGET:api sucBlock:sucBlock failBlock:failBlock];
//        return;
//    }
//    if(requestMethod == RequestMethodPUT)
//    {
//        [self requestPUT:api sucBlock:sucBlock failBlock:failBlock];
//        return;
//    }
//    if(requestMethod == RequestMethodDELETE)
//    {
//        [self requestDELETE:api sucBlock:sucBlock failBlock:failBlock];
//        return;
//    }
//}

- (AFHTTPSessionManager *)createAFHttpManagerForApi:(AbsApi<ApiDelegate>*)api
{
    int timeOut = [api getTimeOut];
    
    if(_manager == nil){
        // 创建会话对象
        _manager = [AFHTTPSessionManager manager];
    }
    
    [self setAcceptableContentTypes:_manager];
    // 设置请求数据的解析方式
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置超时时间
    _manager.requestSerializer.timeoutInterval = timeOut;
    
    // 设置Header
    [self setHeader:_manager withDic:[api getReqHeader]];
    
    return _manager;
}

//- (NSString *)getReqGetUrl:(AbsApi<ApiDelegate>*)api
//{
//    NSString *reqUrl = [api getReqUrl];
//    NSDictionary *paramDic = [api getBody];
//    
//    NSArray *keys = [paramDic allKeys];
//    NSInteger count = keys.count;
//    if(count > 0)
//    {
//        reqUrl = [NSString stringWithFormat:@"%@?",reqUrl];
//        for (NSInteger i = 0; i < count; i++)
//        {
//            if(i != 0)
//            {
//                reqUrl = [NSString stringWithFormat:@"%@&",reqUrl];
//            }
//            NSString *curKey = keys[i];
//            NSString *curValue = [paramDic objectForKey:curKey];
//            reqUrl = [NSString stringWithFormat:@"%@%@=%@",reqUrl,curKey,curValue];
//        }
//    }
//    
//    if(![api isUrlEncode]){
//        return reqUrl;
//    }
//    
//    if(reqUrl.length > 0){
//        reqUrl = [reqUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//        
//    }
//    return reqUrl;
//}



#pragma mark - 私有方法
#pragma mark - Version 1.0.0
// ----------------- Version 1.0.0 -----------------
- (void)postRequest:(AbsApi<ApiDelegate>*)api
           sucBlock:(ResponseSuccessBlock)sucBlock
          failBlock:(ResponseFailureBlock)failBlock;
{
    
    if (self.newVersion) {
        
        CentaResponse *reqResp = [self checkReqInterceptor:api];
        if(nil != reqResp){
            failBlock(reqResp);
            return;
        }
    }
    
    NSString *requestUrl = [api getReqUrl];
    NSDictionary *bodyDic = [api getReqBody];
    Class cls = [api getRespClass];
    AFHTTPSessionManager *manager = [self createAFHttpManagerForApi:api];
    
    [manager POST:requestUrl
       parameters:bodyDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             
                 if (self.newVersion){
                     
                     if (sucBlock)
                         sucBlock([self.interceptorForSuc intercept:task andRespData:responseObject andApi:api]);
                     
                      [self sucFunction:api task:task respData:responseObject];
                
                 }else{
                     
                    if (sucBlock)
                        sucBlock(responseObject);
                     
                     if (self.delegate)
                         [self.delegate respSuc:responseObject andRespClass:cls];
                     
                     
                 }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (self.newVersion){
                 
                if (failBlock)
                    [self failFunction:api task:task error:error failBlock:failBlock];
              
                 if (self.delegate)
                      [self failFunction:api task:task error:error];
                 
             }else{
                 
                 if (failBlock)
                     failBlock(error);
                 if (self.delegate)
                     [self failFunctionTask:task error:error obj:cls];
                 
             }

         }];
}

- (void)getRequest:(AbsApi<ApiDelegate>*)api
          sucBlock:(ResponseSuccessBlock)sucBlock
         failBlock:(ResponseFailureBlock)failBlock;
{
    if (self.newVersion) {
        
        CentaResponse *reqResp = [self checkReqInterceptor:api];
        if(nil != reqResp){
            failBlock(reqResp);
            return;
        }
    }
    
    NSString *requestUrl = [api getReqUrl];
    Class cls = [api getRespClass];
    
    AFHTTPSessionManager *manager = [self createAFHttpManagerForApi:api];
    [manager GET:requestUrl
      parameters:[api getBody]
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (self.newVersion){
                
                if (sucBlock)
                    sucBlock([self.interceptorForSuc intercept:task andRespData:responseObject andApi:api]);
                
                [self sucFunction:api task:task respData:responseObject];
                
            }else{
                
                if (sucBlock)
                    sucBlock(responseObject);
                
                if (self.delegate)
                    [self.delegate respSuc:responseObject andRespClass:cls];
                
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //请求失败
            if (self.newVersion){
                
                if (failBlock)
                    [self failFunction:api task:task error:error failBlock:failBlock];
                
                if (self.delegate)
                    [self failFunction:api task:task error:error];
                
            }else{
                
                if (failBlock)
                    failBlock(error);
                
                if (self.delegate)
                    [self failFunctionTask:task error:error obj:cls];
                
            }
        }];
}

- (void)putRequest:(AbsApi<ApiDelegate>*)api
          sucBlock:(ResponseSuccessBlock)sucBlock
         failBlock:(ResponseFailureBlock)failBlock;
{
    if (self.newVersion) {
        
        CentaResponse *reqResp = [self checkReqInterceptor:api];
        if(nil != reqResp){
            failBlock(reqResp);
            return;
        }
    }
    
    NSString *requestUrl = [api getReqUrl];
    NSDictionary *bodyDic = [api getReqBody];
    Class cls = [api getRespClass];
    AFHTTPSessionManager *manager = [self createAFHttpManagerForApi:api];
    
    [manager PUT:requestUrl
      parameters:bodyDic
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             if (self.newVersion){
                 
                 if (sucBlock)
                     sucBlock([self.interceptorForSuc intercept:task andRespData:responseObject andApi:api]);
                 
                 [self sucFunction:api task:task respData:responseObject];
                 
             }else{
                 
                 if (sucBlock)
                     sucBlock(responseObject);
                 
                 if (self.delegate)
                     [self.delegate respSuc:responseObject andRespClass:cls];
                 
                 
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             //请求失败
             if (self.newVersion){
                 
                 if (failBlock)
                     [self failFunction:api task:task error:error failBlock:failBlock];
                 
                 if (self.delegate)
                     [self failFunction:api task:task error:error];
                 
             }else{
                 
                 if (failBlock)
                     failBlock(error);
                 if (self.delegate)
                     [self failFunctionTask:task error:error obj:cls];
                 
             }
         }];
}

- (void)deleteRequest:(AbsApi<ApiDelegate>*)api
             sucBlock:(ResponseSuccessBlock)sucBlock
            failBlock:(ResponseFailureBlock)failBlock;
{
    if (self.newVersion) {
        CentaResponse *reqResp = [self checkReqInterceptor:api];
        if(nil != reqResp){
            failBlock(reqResp);
            return;
        }
    }
    
    
    NSString *requestUrl = [api getReqUrl];
    NSDictionary *bodyDic = [api getReqBody];
    Class cls = [api getRespClass];
    AFHTTPSessionManager *manager = [self createAFHttpManagerForApi:api];
    
    [manager DELETE:requestUrl
         parameters:bodyDic
            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if (self.newVersion){
                    
                    if (sucBlock)
                        sucBlock([self.interceptorForSuc intercept:task andRespData:responseObject andApi:api]);
                    
                    [self sucFunction:api task:task respData:responseObject];
                    
                }else{
                    
                    if (sucBlock)
                        sucBlock(responseObject);
                    
                    if (self.delegate)
                        [self.delegate respSuc:responseObject andRespClass:cls];
                    
                    
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //请求失败
                if (self.newVersion){
                    
                    if (failBlock)
                        [self failFunction:api task:task error:error failBlock:failBlock];
                    
                    if (self.delegate)
                        [self failFunction:api task:task error:error];
                    
                }else{
                    
                    if (failBlock)
                        failBlock(error);
                    if (self.delegate)
                        [self failFunctionTask:task error:error obj:cls];
                    
                }
            }];
}






//#pragma mark - Version 1.0.5
//- (void)requestPOST:(AbsApi<ApiDelegate>*)api
//           sucBlock:(RespSucBlock)sucBlock
//          failBlock:(RespFailBlock)failBlock;
//{
//    CentaResponse *reqResp = [self checkReqInterceptor:api];
//    if(nil != reqResp){
//        failBlock(reqResp);
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
//             if (sucBlock) {
//                 sucBlock([self.interceptorForSuc intercept:task andRespData:responseObject andApi:api]);
//             }
//
//         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//             // 请求失败
//             [self failFunction:api task:task error:error failBlock:failBlock];
//         }];
//}
//
//- (void)requestGET:(AbsApi<ApiDelegate>*)api
//          sucBlock:(RespSucBlock)sucBlock
//         failBlock:(RespFailBlock)failBlock;
//{
//    CentaResponse *reqResp = [self checkReqInterceptor:api];
//    if(nil != reqResp){
//        failBlock(reqResp);
//        return;
//    }
//
//    NSString *requestUrl = [api getReqUrl];
//    //    NSString *requestUrl = [self getReqGetUrl:api];
//    AFHTTPSessionManager *manager = [self createAFHttpManagerForApi:api];
//    [manager GET:requestUrl
//      parameters:[api getBody]
//        progress:^(NSProgress * _Nonnull downloadProgress) {
//
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            // 请求成功
//            if (sucBlock) {
//                sucBlock([self.interceptorForSuc intercept:task andRespData:responseObject andApi:api]);
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            // 请求失败
//            [self failFunction:api task:task error:error failBlock:failBlock];
//        }];
//}
//
//- (void)requestPUT:(AbsApi<ApiDelegate>*)api
//          sucBlock:(RespSucBlock)sucBlock
//         failBlock:(RespFailBlock)failBlock;
//{
//    CentaResponse *reqResp = [self checkReqInterceptor:api];
//    if(nil != reqResp){
//        failBlock(reqResp);
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
//             if (sucBlock) {
//                 sucBlock([self.interceptorForSuc intercept:task andRespData:responseObject andApi:api]);
//             }
//
//         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//             // 请求失败
//             [self failFunction:api task:task error:error failBlock:failBlock];
//         }];
//}
//
//- (void)requestDELETE:(AbsApi<ApiDelegate>*)api
//             sucBlock:(RespSucBlock)sucBlock
//            failBlock:(RespFailBlock)failBlock;
//{
//    CentaResponse *reqResp = [self checkReqInterceptor:api];
//    if(nil != reqResp){
//        failBlock(reqResp);
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
//                if (sucBlock) {
//                    sucBlock([self.interceptorForSuc intercept:task andRespData:responseObject andApi:api]);
//                }
//
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                // 请求失败
//                [self failFunction:api task:task error:error failBlock:failBlock];
//            }];
//}
// 请求成功
- (void)sucFunction:(AbsApi<ApiDelegate> *)api task:(id)task respData:(id)respData
{
    if (self.delegate)
    {
        [self.delegate respSuc:[self.interceptorForSuc intercept:task andRespData:respData andApi:api]];
    }
}
#pragma mark - 辅助方法

- (CentaResponse *)checkReqInterceptor:(AbsApi<ApiDelegate>*)api
{
    CentaResponse *reqResp = nil;
    for (InterceptorForReq *item in self.interceptorsForReq) {
        CentaResponse *resp = [item intercept:api];
        BOOL valid = resp.suc;
        if(!valid)
        {
            reqResp = resp;
            break;
        }
    }
    return reqResp;
}

// 请求失败
- (void)failFunction:(AbsApi<ApiDelegate> *)api task:(id)task error:(id)error
{
    
        CentaResponse *respResp = [self checkRespInterceptor:api task:task error:error];
        if(nil != respResp){
            [self.delegate respFail:respResp];
            return;
        }
        
        if (self.delegate) {
            [self.delegate respFail:[self error2CentaResponse:error andApi:api]];
        }
        

}

// 请求失败
- (void)failFunction:(AbsApi<ApiDelegate> *)api
                task:(id)task
               error:(id)error
           failBlock:(RespFailBlock)failBlock;
{
    CentaResponse *respResp = [self checkRespInterceptor:api task:task error:error];
    if(!failBlock){
        return;
    }
    
    if(nil != respResp){
        failBlock(respResp);
        return;
    }
    failBlock([self error2CentaResponse:error andApi:api]);
}
// 请求失败
- (void)failFunctionTask:(NSURLSessionDataTask*)task error:(NSError*)error obj:(Class)cls {
    
    NSHTTPURLResponse *urlResp = (NSHTTPURLResponse *)task.response;
    NSError *newError = [NSError errorWithDomain:error.domain code:urlResp.statusCode userInfo:error.userInfo];
    
    if (self.delegate) {
        [self.delegate respFail:newError andRespClass:cls];
    }
    
}



- (CentaResponse *)checkRespInterceptor:(AbsApi<ApiDelegate>*)api
                                   task:(NSURLSessionDataTask * _Nullable)task
                                  error:(NSError * _Nonnull)error
{
    CentaResponse *reqResp = nil;
    for (InterceptorForRespFail *item in self.interceptorsForResp) {
        CentaResponse *resp = [item intercept:task andRespData:error andApi:api];
        BOOL valid = resp.suc;
        if(!valid)
        {
            reqResp = resp;
            break;
        }
    }
    return reqResp;
}



- (void)setAcceptableContentTypes:(AFHTTPSessionManager *)manager
{
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"text/javascript",@"text/plain",@"text/json",@"application/json", nil]];
}

- (void)setHeader:(AFHTTPSessionManager *)manager
          withDic:(NSDictionary *)header;
{
    if(!header)
    {
        return;
    }
    
    NSArray *keys = [header allKeys];
    NSInteger count = [keys count];
    for (int i = 0; i < count; i++)
    {
        NSString *key = keys[i];
        NSString *value = [header objectForKey:key];
        [manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
}

- (void)addIntercepterForReq:(InterceptorForReq *)interceptor
{
    [self.interceptorsForReq addObject:interceptor];
}

- (void)addIntercepterForRespFail:(InterceptorForRespFail *)interceptor
{
    [self.interceptorsForResp addObject:interceptor];
}

- (CentaResponse *)error2CentaResponse:(NSError *)error andApi:(AbsApi<ApiDelegate> *)api
{
    CentaResponse *resp = [[CentaResponse alloc] init];
    resp.code = error.code;
    resp.msg = error.localizedDescription;
    resp.data = error.userInfo;
    resp.api = (BaseApi *)api;
    
    return resp;
}

@end

