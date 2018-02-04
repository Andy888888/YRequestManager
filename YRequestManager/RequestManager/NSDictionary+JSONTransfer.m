//
//  NSDictionary+JSONTransfer.m
//  YRequestManager
//
//  Created by 燕文强 on 2018/2/2.
//  Copyright © 2018年 燕文强. All rights reserved.
//

#import "NSDictionary+JSONTransfer.h"

@implementation NSDictionary (JSONTransfer)

/// 字典转换为JSON串
- (NSString *)JSONString
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil)
    {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    else
    {
        return nil;
    }
}

@end
