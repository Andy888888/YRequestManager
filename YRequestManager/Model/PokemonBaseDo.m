//
//  PokemonDo.m
//  RequestManagerDemo
//
//  Created by 燕文强 on 2017/12/3.
//  Copyright © 2017年 燕文强. All rights reserved.
//

#import "PokemonBaseDo.h"

@implementation PokemonBaseDo

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"status":@"status",
             @"pokemon":@"pokemon"
             };
}

@end
