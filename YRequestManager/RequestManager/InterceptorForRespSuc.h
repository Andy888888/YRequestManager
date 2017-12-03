//
//  NetworkInterceptor.h
//  APlus
//
//  Created by 燕文强 on 2017/9/20.
//  Copyright © 2017年 燕文强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CentaResponse.h"
#import "ApiDelegate.h"

/// 网络数据返回拦截器
@interface InterceptorForRespSuc : NSObject

/// 数据返回后的拦截，建议不要直接重写此方法
- (CentaResponse *)intercept:(id)task andRespData:(id)respData andApi:(AbsApi<ApiDelegate> *)api;

/// 数据转换过程
- (CentaResponse *)convertData:(id)task andRespData:(id)respData andApi:(AbsApi<ApiDelegate> *)api;

/// 响应数据的检查过程
- (CentaResponse *)checkData:(CentaResponse *)resp;

- (CentaResponse *)createResponse;

@end
