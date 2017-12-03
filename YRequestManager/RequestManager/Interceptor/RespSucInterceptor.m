//
//  RespSucInterceptor.m
//  APlus
//
//  Created by 燕文强 on 2017/9/24.
//  Copyright © 2017年 燕文强. All rights reserved.
//

#import "RespSucInterceptor.h"

@implementation RespSucInterceptor

- (CentaResponse *)convertData:(id)task andRespData:(id)respData andApi:(AbsApi<ApiDelegate> *)api
{
#warning 在这里处理数据转换
    return [super convertData:task andRespData:respData andApi:api];
}

@end
