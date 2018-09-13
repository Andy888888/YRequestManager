//
//  RequestManager.h
//  AF_RequestManager
//
//  Created by 燕文强 on 16/7/27.
//  Copyright © 2016年 燕文强. All rights reserved.
//

#import "BaseServiceManager.h"

// ----------------- Version 1.0.0 -----------------
/// ResponseDelegate 数据响应回调协议
/// @warning 请不要随便修改
//@protocol ResponseDelegate <NSObject>
///// 响应成功
//- (void)respSuc:(id)data andRespClass:(id)cls;
///// 响应失败
//- (void)respFail:(NSError *)error andRespClass:(id)cls;
//
//
//
///// 响应成功
//- (void)respSuc:(CentaResponse *)resData;
///// 响应失败
//- (void)respFail:(CentaResponse *)error;
//
//@end




// ----------------- Version 1.0.0 -----------------

/// ResponseDelegate 数据响应回调协议
/// @warning 请不要随便修改
//@protocol YResponseDelegate <NSObject>
//
///// 响应成功
//- (void)respSuc:(CentaResponse *)resData;
///// 响应失败
//- (void)respFail:(CentaResponse *)error;
//
//@end

/// RequestManager 继承自BaseServiceManager
/// @warning 设计此Manager主要目的是，后期不采用AFNetWorking时，可在本类的发送方法sendRequest...中切换其他第三方请求框架即可，而不需要项目中到处修改AFNetWorking请求为其他方式请求，同时担任着控制第三方请求的角色；因此，即使看不惯本类，也不要修改；另外，本类增加了Protocal回调数据方式请求
/// @warning 请不要随便修改



@interface RequestManager : BaseServiceManager

//@property (nonatomic,assign) id<ResponseDelegate> delegate;


/**
 初始化方法 默认为1.0版本

 @param delegate delegate必须传否则警告⚠️crash 必须实现代理方法否则crash
 @return RequestManager对象
 */
+ (id)initManagerWithDelegate:(id<ResponseDelegate>_Nonnull)delegate;


/**
 初始化方法 是否采用新版本

 @param delegate  delegate必须传否则警告⚠️crash 必须实现代理方法否则crash
 @param newVersion YES为使用1.5版本  默认使用1.0版本
 @return RequestManager对象
 */
+ (id)initManagerWithDelegate:(id<ResponseDelegate>_Nonnull)delegate withNewVersion:(BOOL)newVersion;

/**
 初始化方法 是否采用拦截器
 
 @param delegate  delegate必须传否则警告⚠️crash 必须实现代理方法否则crash
 @param Interceptor YES为使用1.5版本  默认使用1.0版本
 @return RequestManager对象
 */
+ (id)initManagerWithDelegate:(id<ResponseDelegate>_Nonnull)delegate withInterceptor:(BOOL)Interceptor;


- (void)sendRequest:(AbsApi<ApiDelegate>*)api;


/**
 + (id)initManagerWithDelegate:(id<ResponseDelegate>_Nonnull)delegate withNewVersion:(BOOL)newVersion
 
 即: newVersion属性
 
 1.初期保留此方法
 2.过渡期使其过期
 2.最后废除
 
 */

+ (void)test1 NS_DEPRECATED(1_5, 1_5, 1_5, 1_5, "此方法已过期 请使用 + (id)initManagerWithDelegate:");

+ (void)test2 NS_UNAVAILABLE;



//// ----------------- Version 1.0.0 -----------------
//
///// ResponseDelegate 数据响应回调协议
//@property (nonatomic,assign) id<YResponseDelegate> ydelegate;
//+ (id)defaultManager:(id<ResponseDelegate>)delegate;
//+ (id)initManagerWithYDelegate:(id<YResponseDelegate>)delegate;
///// 发送数据请求，参数为继承AbsApi抽象类，且遵守BaseApiDelegate协议 的对象
//- (void)request:(AbsApi<ApiDelegate>*)api;

@end
