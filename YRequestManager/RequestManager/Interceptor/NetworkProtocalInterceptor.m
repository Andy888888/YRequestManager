//
//  NetworkProtocalInterceptor.m
//  APlus
//
//  Created by 燕文强 on 2017/9/22.
//  Copyright © 2017年 燕文强. All rights reserved.
//

#import "NetworkProtocalInterceptor.h"

@implementation NetworkProtocalInterceptor

- (CentaResponse *)intercept:(id)task andRespData:(NSError *)respData andApi:(AbsApi<ApiDelegate> *)api
{
    CentaResponse *resp = [super intercept:task andRespData:respData andApi:api];
    
    NSInteger code = resp.code;
    NSString *msg = @"";
    
    switch (code) {
        case 400:
        {
            msg = @"处理失败";
            NSLog(@"Http Network Protocal: 服务端业务逻辑处理失败！");
        }
            break;
            
        case 404:
        {
            msg = @"请求失败";
            NSLog(@"Http Network Protocal: 请检查你的请求地址！");
        }
            break;
            
        case 500:
        {
            msg = @"服务器内部出错";
            NSLog(@"Http Network Protocal: 请联系Api开发人员检查服务器代码！");
        }
            break;
            
        case 504:
        {
            msg = @"请求超时";
            NSLog(@"Http Network Protocal: 请求超时！");
        }
            break;
            
        default:
        {
            msg = @"";
        }
            break;
    }
    
    if(msg)
    {
        resp.suc = false;
    }
    resp.msg = msg;
    
    return resp;
}

@end
