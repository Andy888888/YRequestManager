//
//  ApiDelegate.h
//  AF_RequestManager
//
//  Created by 燕文强 on 16/7/26.
//  Copyright © 2016年 燕文强. All rights reserved.
//

#import <UIKit/UIKit.h>

/// ApiDelegate 需要遵守的协议，用来规范请求参数以及设置
/// @warning 请不要随便修改
@protocol ApiDelegate <NSObject>

/// 必须实现
@required

/// 请求url
/// @warning 默认为nil，遵守实现者必须实现
- (NSString *)getReqUrl;

/// 请求header
/// @warning 默认为nil
- (NSDictionary *)getReqHeader;

 /// 请求body
/// @warning 默认为nil，遵守实现者必须实现
- (NSDictionary *)getReqBody;

/// 请求方式
/// @warning 默认为Post（RequestMethodPOST）
- (int)getRequestMethod;

/// 请求超时时间
/// @warning 默认超时时间为5秒
- (int)getTimeOut;

@end
