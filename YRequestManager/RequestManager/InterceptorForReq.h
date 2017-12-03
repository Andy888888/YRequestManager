//
//  InterceptorForReq.h
//  APlus
//
//  Created by 燕文强 on 2017/9/20.
//  Copyright © 2017年 燕文强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CentaResponse.h"
#import "BaseApi.h"

/// 网络数据请求拦截器
@interface InterceptorForReq : NSObject

/// 发出请求前的拦截，一般用来 打印请求地址／参数／拦截本次请求
- (CentaResponse *)intercept:(AbsApi<ApiDelegate>*)api;
- (CentaResponse *)createResponse;

@end
