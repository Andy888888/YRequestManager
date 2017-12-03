//
//  InterceptorForRespFail.h
//  APlus
//
//  Created by 燕文强 on 2017/9/24.
//  Copyright © 2017年 燕文强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CentaResponse.h"
#import "ApiDelegate.h"

@interface InterceptorForRespFail : NSObject

/// 数据返回后的拦截，一般用来 拦截错误信息
- (CentaResponse *)intercept:(id)task andRespData:(NSError *)respData andApi:(AbsApi<ApiDelegate>*)api;
- (CentaResponse *)createResponse;

@end
