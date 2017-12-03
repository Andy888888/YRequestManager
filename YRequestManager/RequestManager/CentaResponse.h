//
//  CentaResponse.h
//  APlus
//
//  Created by 燕文强 on 2017/9/20.
//  Copyright © 2017年 燕文强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApi.h"

/// 统一的响应数据流格式
@interface CentaResponse : NSObject

@property (nonatomic,assign) BOOL suc;
@property (nonatomic,assign) NSInteger code;
@property (nonatomic,strong) NSString *msg;
@property (nonatomic,strong) BaseApi *api;
@property (nonatomic,strong) id data;

@end
