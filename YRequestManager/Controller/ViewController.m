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
#import "NSDictionary+Json.h"

@interface ViewController ()<ResponseDelegate,YResponseDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)click:(id)sender {
    [_resultLabel setText:@"response："];
//    [self requestVersion100];
    [self requestVersion105];
}

- (void)requestVersion100
{
    PokemonPositionApi *api = [[PokemonPositionApi alloc]init];
    api.user = @"andy";
    api.pwd = @"pwd";
    
    RequestManager *reqManager = [RequestManager initManagerWithDelegate:self];
    [reqManager sendRequest:api];
    
//    [reqManager sendRequest:api sucBlock:^(id result) {
//        NSDictionary *dic = result;
//        NSString *dicStr = [dic JSONString];
//        NSLog(dicStr);
//    } failBlock:^(NSError *error) {
//        NSString *resultCode = [NSString stringWithFormat:@"@ld",error.code];
//        NSLog(resultCode);
//    }];
}

- (void)requestVersion105
{
    PokemonPositionApi *api = [[PokemonPositionApi alloc]init];
    api.user = @"a n d y";
    api.pwd = @"pwd";
    
    RequestManager *reqManager = [RequestManager defaultManager:self];
    [reqManager setInterceptorForSuc:[DataConvertInterceptor new]];
    [reqManager request:api];
    
//    [reqManager request:api sucBlock:^(CentaResponse *result) {
//        if(result.suc){
//            PkPositionDo *position = result.data;
//            NSString *status = position.status;
//            NSLog(status);
//        }else{
//            NSLog(result.msg);
//        }
//    } failBlock:^(CentaResponse *error) {
//        NSLog(error.msg);
//    }];
}

- (void)respSuc:(CentaResponse *)resData
{
    if(resData.suc){
        PkPositionDo *position = resData.data;
        NSString *status = position.status;
        NSString *resultTxt = [@"response：" stringByAppendingString:status];
        [_resultLabel setText:resultTxt];
        NSLog(status);
    }else{
        NSLog(resData.msg);
    }
}

- (void)respFail:(CentaResponse *)error
{
    NSLog(error.msg);
}

- (void)respSuc:(id)data andRespClass:(id)cls{
    NSDictionary *dic = data;
    NSString *dicStr = [dic JsonString];
    NSLog(dicStr);
}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    NSString *resultCode = [NSString stringWithFormat:@"%ld",error.code];
    NSLog(resultCode);
}



@end
