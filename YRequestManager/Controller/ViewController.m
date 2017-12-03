//
//  ViewController.m
//  YRequestManager
//
//  Created by 燕文强 on 2017/12/3.
//  Copyright © 2017年 燕文强. All rights reserved.
//

#import "ViewController.h"
#import "RequestManager.h"
#import "PokemonPositionApi.h"
#import "PkPositionDo.h"
#import "DataConvertInterceptor.h"

@interface ViewController ()<ResponseDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)click:(id)sender {
    PokemonPositionApi *api = [[PokemonPositionApi alloc]init];
    api.user = @"andy";
    api.pwd = @"pwd";
    
    RequestManager *reqManager = [RequestManager defaultManager:self];
    [reqManager setInterceptorForSuc:[DataConvertInterceptor new]];
    [reqManager sendRequest:api];
}

- (void)respSuc:(CentaResponse *)resData
{
    if(resData.suc){
        PkPositionDo *position = resData.data;
        NSString *status = position.status;
        NSLog(status);
    }else{
        NSLog(resData.msg);
    }
}

- (void)respFail:(CentaResponse *)error
{
    NSLog(error.msg);
}


@end
