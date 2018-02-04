//
//  NSDictionary+JSONTransfer.h
//  YRequestManager
//
//  Created by 燕文强 on 2018/2/2.
//  Copyright © 2018年 燕文强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONTransfer)
/// 字典转换为JSON串
- (NSString *)JSONString;
@end
