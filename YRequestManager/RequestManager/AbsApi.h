//
//  AbsApi.h
//  AF_RequestManager
//
//  Created by 燕文强 on 16/7/27.
//  Copyright © 2016年 燕文强. All rights reserved.
//

#import <Foundation/Foundation.h>

/// RequestMethod 请求方式枚举
/// @warning 请不要随便修改
enum RequestMethod
{
    /// Post请求方式
    RequestMethodPOST = 1,
    /// Get请求方式
    RequestMethodGET = 2,
    /// Put请求方式
    RequestMethodPUT = 3,
    /// Delete请求方式
    RequestMethodDELETE = 4
};

/// AbsApi 请求抽象类
/// @warning 请不要随便修改
@interface AbsApi : NSObject

/// 请求域名url
/// @warning 默认为nil，遵守实现者必须实现
- (NSString *)getRootUrl;
/// 请求url后半部分
/// @warning 默认为nil，遵守实现者必须实现
- (NSString *)getPath;
/// 基本header
/// @warning 默认为nil，若有每个请求必填的header字段，请实现此方法
- (NSMutableDictionary *)getBaseHeader;
/// 基本header以外的请求header
/// @warning 默认为nil，遵守实现者必须实现
- (NSDictionary *)getHeader;
/// 基本body
/// @warning 默认为nil，若有每个请求必填的body字段，请实现此方法
- (NSMutableDictionary *)getBaseBody;
/// 基本body以外的请求body
/// @warning 默认为nil，遵守实现者必须实现
- (NSDictionary *)getBody;

/// 请求返回数据实体Class
/// @warning 默认为nil，用来区分返回来的数据类型，以及指定序列化dic为实体对象的class类型
- (Class)getRespClass;

@end
