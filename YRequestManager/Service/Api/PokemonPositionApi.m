//
//  PokemonPositionApi.m
//  RequestManagerDemo
//
//  Created by 燕文强 on 2017/12/3.
//  Copyright © 2017年 燕文强. All rights reserved.
//

#import "PokemonPositionApi.h"
#import "PkPositionDo.h"

@implementation PokemonPositionApi

- (NSString *)getPath
{
    return @"map/data/34.00/-118.5";
}

- (NSDictionary *)getBody
{
    return @{@"User":_user,@"Pwd":_pwd};
}

- (Class)getRespClass
{
    return [PkPositionDo class];
}

- (int)getRequestMethod
{
    return RequestMethodGET;
}

@end
