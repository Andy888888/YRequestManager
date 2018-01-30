# YRequestManager

###### Base AFNetworking Core Network Request Framework
![Logo](https://raw.githubusercontent.com/Andy888888/Wq_RequestManager/master/AF_RequestManager/Assets.xcassets/AppIcon.appiconset/network_58.png "AF_RequestManager 图标")<br><br>

## 使用
`pod search YRequestManager`

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
* `getRequestMethod`用来配置该请求方式，目前设置了两种模式，用enum枚举RequestMethod来区分，可返回`RequestMethodPOST`（Post请求）或者`RequestMethodGET`（Get请求）,其他的请求方式后期补充。<br>
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
- (void)sendRequest:(AbsApi<ApiDelegate>*)api
           sucBlock:(ResponseSuccessBlock)sucBlock
           failBlock:(ResponseFailureBlock)failBlock;
```
该方法使用Block回调来发送请求，api参数为继承AbsApi抽象类，且遵守`ApiDelegate`协议的对象，(PS:`BaseApi就符合该约束，凡继承BaseApi的对象都符合该参数约束`) `BaseServiceManager`内部通过api对象配置来发送请求。`sucBlock`，`failBlock`为请求成功／失败回调。<br><br><br>

### 5.RequestManager
继承自BaseServiceManager；设计此Manager主要目的是，后期不采用AFNetWorking时，可在本类的发送方法sendRequest...中切换其他第三方请求框架即可，而不需要项目中到处修改AFNetWorking请求为其他方式请求，同时担任着控制第三方请求的角色；因此，即使看不惯本类，也不要修改；另外，本类增加了Protocal回调数据方式请求。
```Object-C
/// ResponseDelegate 数据响应回调协议
@property (nonatomic,assign) id<ResponseDelegate> delegate;

+ (id)initManagerWithDelegate:(id<ResponseDelegate>)delegate;
/// 发送数据请求，参数为继承AbsApi抽象类，且遵守BaseApiDelegate协议 的对象
- (void)sendRequest:(AbsApi<ApiDelegate>*)api;
```
我们可以直接使用`initManagerWithDelegate:`方法来初始化RequestManager对象，将数据回调协议delegate传入。<br>
使用`sendRequest:`方法来发送请求，同父类一致，api参数为继承AbsApi抽象类，且遵守`BaseApiDelegate`协议的对象。而上述`BaseApi`就符合这一点，而BaseApi如果不符合你的口味，你可以来自定义一个继承AbsApi又遵守BaseApiDelegate协议的对象。
