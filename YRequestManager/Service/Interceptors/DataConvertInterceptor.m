//
//  APlusRespinterceptor.m
//  APlus
//
//  Created by 燕文强 on 2017/9/25.
//  Copyright © 2017年 燕文强. All rights reserved.
//

#import "DataConvertInterceptor.h"
#import "YYModel.h"

@implementation DataConvertInterceptor

- (CentaResponse *)convertData:(id)task andRespData:(id)respData andApi:(AbsApi<ApiDelegate> *)api
{
#warning 在这里处理数据转换
    CentaResponse *resp =  [super convertData:task andRespData:respData andApi:api];
    NSDictionary *dic = resp.data;
    
    // 要转换的目标实体
    Class cls = api.getRespClass;
    resp.data = [cls yy_modelWithDictionary:dic];
    
    return resp;
}

@end
