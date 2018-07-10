//
//  PokemonBaseApi.m
//  RequestManagerDemo
//
//  Created by 燕文强 on 2017/12/3.
//  Copyright © 2017年 燕文强. All rights reserved.
//

#import "PokemonBaseApi.h"
#import "PokemonBaseDo.h"

@implementation PokemonBaseApi

- (NSString *)getRootUrl
{
    return @"https://pokevision.com/";
}

- (int)getTimeOut
{
    return 30;
}

- (int)getRequestMethod
{
    return RequestMethodGET;
}

- (NSString *)checkRespData:(id)data
{
    PokemonBaseDo *pokemon = data;
    NSString *status = pokemon.status;
//
//    NSDictionary *dic = data;
//    NSString *status = dic[@"status"];
    if(![status isEqualToString:@"success"]){
        return @"查询失败";
    }
    return nil;
}

- (BOOL)logEnable{
    return NO;
}

@end
