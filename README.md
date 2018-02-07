![Logo](https://raw.githubusercontent.com/Andy888888/Wq_RequestManager/master/AF_RequestManager/Assets.xcassets/AppIcon.appiconset/network_58.png "YRequestManager 图标")<br><br>
# YRequestManager

###### Base AFNetworking Core Network Request Framework

![Description](https://raw.githubusercontent.com/Andy888888/YRequestManager/master/YRequestManager.jpeg "YRequestManager图解")<br><br>

## pod 使用
`pod search YRequestManager`  
`pod 'YRequestManager'`

## 结构概览
    1.ApiDelegate
    2.AbsApi
    3.BaseApi
    4.BaseServiceManager
    5.RequestManager

## 详解
### 1.ApiDelegate   Protocal协议
该协议规范了凡遵守该协议的Api对象都拥有`getReqUrl`,`getReqHeader`,`getReqBody`,`getRequestMethod`,`getTimeOut`方法。这种设计方式借鉴了Java，C#语法的Interface接口的设计思想。<br>
* `getReqUrl`       用来配置请求地址Url，遵守者实现该方法需返回一个`NSString`对象。<br>
* `getReqHeader`    用来配置请求Header，遵守者实现该方法需返回一个`NSDictionary`对象。<br>
* `getReqBody`      用来配置请求Body，遵守者实现该方法需返回一个`NSDictionary`对象。<br>
* `getRequestMethod`用来配置该请求方式，用enum枚举RequestMethod来区分，可返回`RequestMethodPOST`（Post请求）、`RequestMethodGET`（Get请求）`RequestMethodPUT`（Put请求）、`RequestMethodDELETE`（Delete请求）。<br>
* `getTimeOut`      用来配置请求超时时间。<br><br><br>


### 2.AbsApi    abstract抽象类
请求抽象类，规范了继承自AbsApi需要实现的方法。这种设计方式借鉴了Java，C#语法的abstract抽象类的设计思想。
* `getRootUrl`      请求域名url。默认为nil，遵守实现者必须实现。
* `getPath`         请求url后半部分。默认为nil，遵守实现者必须实现。
* `getBaseHeader`   基本header。默认为nil，若有每个请求必填的header字段，请实现此方法。
* `getHeader`       基本header以外的请求header。默认为nil，遵守实现者必须实现。
* `getBaseBody`     基本body。默认为nil，若有每个请求必填的body字段，请实现此方法。
* `getBody`         基本body以外的请求body。默认为nil，遵守实现者必须实现
* `getRespClass`    用来指定该请求返回的数据实体Class，遵守者重写该方法需返回一个Class类型［Entity class］，将返回的数据转换成指定数据实体对象。同时在同一页面中发起n个不同api请求后，返回的数据，我们可以通过class来区别。<br><br><br>


### 3.BaseApi   请求Api基类
请求基类，继承自`AbsApi`，且遵守了`ApiDelegate`协议。
内部实现了`ApiDelegate`协议的方法，大家使用时直接继承`BaseApi`。而如果BaseApi如果不符合你的口味，你可以来自定义一个继承AbsApi又遵守BaseApiDelegate协议的对象<br><br><br>

### 4.BaseServiceManager
用来使用AFNetWorking发送请求，只是个管理者，本身并不具备发送请求能力；目前依赖于AFNetWorking来发送网络请求；在内部封装了一些默认创建`AFHTTPSessionManager`的方法。
```Object-C
/// 使用block方式发送数据请求；api：发送参数，sucBlock：成功回调，failBlock：失败回调
- (void)request:(AbsApi<ApiDelegate>*)api
       sucBlock:(RespSucBlock)sucBlock
      failBlock:(RespFailBlock)failBlock;
```
该方法使用Block回调来发送请求，api参数为继承AbsApi抽象类，且遵守`ApiDelegate`协议的对象，(PS:`BaseApi就符合该约束，凡继承BaseApi的对象都符合该参数约束`) `BaseServiceManager`内部通过api对象配置来发送请求。`sucBlock`，`failBlock`为请求成功／失败回调。<br><br><br>

### 5.RequestManager
继承自BaseServiceManager；设计此Manager主要目的是，后期不采用AFNetWorking时，可在本类的发送方法sendRequest...中切换其他第三方请求框架即可，而不需要项目中到处修改AFNetWorking请求为其他方式请求，同时担任着控制第三方请求的角色；因此，即使看不惯本类，也不要修改；另外，本类增加了Protocal回调数据方式请求。
```Object-C
/// ResponseDelegate 数据响应回调协议
@property (nonatomic,assign) id<YResponseDelegate> ydelegate;

+ (id)initManagerWithDelegate:(id<ResponseDelegate>)delegate;
/// 发送数据请求，参数为继承AbsApi抽象类，且遵守BaseApiDelegate协议 的对象
- (void)sendRequest:(AbsApi<ApiDelegate>*)api;
```
我们可以直接使用`initManagerWithYDelegate:`或者`defaultManager`方法来初始化RequestManager对象，将数据回调协议delegate传入。<br>
使用`request:`方法来发送请求，同父类一致，api参数为继承AbsApi抽象类，且遵守`BaseApiDelegate`协议的对象。而上述`BaseApi`就符合这一点，而BaseApi如果不符合你的口味，你可以来自定义一个继承AbsApi又遵守BaseApiDelegate协议的对象。

<br><br><br><br><br><br><br><br>

## 使用方式

### 1.Api配置类

* Api配置类使用

```Object-C
// 导入
#import "BaseApi.h"

// PokemonBaseApi继承自BaseApi
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
    if(![status isEqualToString:@"success"]){
        return @"查询失败";
    }
    return nil;
}
@end
```

```Object-C
// PokemonPositionApi继承自PokemonBaseApi
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

```

* Api配置类的实例化

```Object-C

// 初始化要请求的接口配置
PokemonPositionApi *api = [[PokemonPositionApi alloc]init];
// 设置配置：请求body参数
api.user = @"andy";
api.pwd = @"pwd";

```
<br><br><br><br><br><br>

### 2.RequestManager请求

* RequestManager请求

```Object-C

#import "RequestManager.h"

// 初始化请求管理类
RequestManager *reqManager = [RequestManager defaultManager:self];
// 添加响应成功后，数据转换实体方式拦截器
[reqManager setInterceptorForSuc:[DataConvertInterceptor new]];
// 发送请求：Protocol方式接收数据
[reqManager request:api];

// 发送请求：Block方式接收数据
[reqManager request:api sucBlock:^(CentaResponse *result) {
        if(result.suc){
            PkPositionDo *position = result.data;
            NSString *status = position.status;
            NSLog(status);
        }else{
            NSLog(result.msg);
        }
    } failBlock:^(CentaResponse *error) {
        NSLog(error.msg);
    }];

```
<br><br>

* DataConvertInterceptor （继承自InterceptorForRespSuc）

    DataConvertInterceptor并非框架自带，因为框架不应该绑架业务层使用什么做数据转换，  
    因此，这个过程开放出来，自行决定。（示例代码中是使用yyModel转换）

```Object-C

@implementation DataConvertInterceptor

- (CentaResponse *)convertData:(id)task andRespData:(id)respData andApi:(AbsApi<ApiDelegate> *)api
{
    CentaResponse *resp =  [super convertData:task andRespData:respData andApi:api];
    NSDictionary *dic = resp.data;
    
    // 使用yymodel转换成目标实体
    Class cls = api.getRespClass;
    resp.data = [cls yy_modelWithDictionary:dic];
    
    return resp;
}
@end

```
