//
//  RequestManager.h
//  AF_RequestManager
//
//  Created by 燕文强 on 16/7/27.
//  Copyright © 2016年 燕文强. All rights reserved.
//

#import "BaseServiceManager.h"

/// ResponseDelegate 数据响应回调协议
/// @warning 请不要随便修改
@protocol ResponseDelegate <NSObject>

/// 响应成功
- (void)respSuc:(CentaResponse *)resData;
/// 响应失败
- (void)respFail:(CentaResponse *)error;

@end

/// RequestManager 继承自BaseServiceManager
/// @warning 设计此Manager主要目的是，后期不采用AFNetWorking时，可在本类的发送方法sendRequest...中切换其他第三方请求框架即可，而不需要项目中到处修改AFNetWorking请求为其他方式请求，同时担任着控制第三方请求的角色；因此，即使看不惯本类，也不要修改；另外，本类增加了Protocal回调数据方式请求
/// @warning 请不要随便修改
@interface RequestManager : BaseServiceManager

/// ResponseDelegate 数据响应回调协议
@property (nonatomic,assign) id<ResponseDelegate> delegate;

+ (id)defaultManager:(id<ResponseDelegate>)delegate;
+ (id)initManagerWithDelegate:(id<ResponseDelegate>)delegate;
/// 发送数据请求，参数为继承AbsApi抽象类，且遵守BaseApiDelegate协议 的对象
- (void)sendRequest:(AbsApi<ApiDelegate>*)api;

@end
