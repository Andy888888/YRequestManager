//
//  PkPositionDo.m
//  RequestManagerDemo
//
//  Created by 燕文强 on 2017/12/3.
//  Copyright © 2017年 燕文强. All rights reserved.
//

#import "PkPositionDo.h"

@implementation PkPositionDo

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"status":@"status",
             @"pokemon":@"pokemon"
             };
}

@end
