

Pod::Spec.new do |s|

  s.name         = "YRequestManager"
  s.version      = "1.0.8"
  s.summary      = "Network Request Manager Base IOS AFNetworking Framework "
  s.description  = <<-DESC
                          基于AFNetworking作为网络请求核心，封装的网络请求管理工具。通过Api类作为请求配置描述，Manager做为管理发送方来发出请求；默认提供了三个拦截器：NetworkProtocalInterceptor（错误后处理状态码，网络层），ReqLogInterceptor（发起请求前打印日志），RespSucInterceptor（响应成功后做数据转实体，可用第三方转换工具）；RequestManager提供了默认实例化方法：defaultMamanger，会把默认的三个拦截器加入进来，如果项目中不想用这三个拦截器，或不满足需求，可继承他们的父类自己重写，当然，RequestManager的实例化方法也要改为：initManagerWithYDelegate。
                   DESC

  s.homepage     = "https://github.com/Andy888888/YRequestManager"
  s.license      = "MIT"
  s.author       = { "燕文强" => "yanwenqiang1991@foxmail.com" }
  s.platform     = :ios,'7.0'
  s.ios.deployment_target = '7.0'

  s.source       = { :git => "https://github.com/Andy888888/YRequestManager.git", :tag => "#{s.version}" }
  s.source_files = "YRequestManager/RequestManager/**/*.{h,m}"
  s.framework    = "UIKit", "Foundation"
  # s.exclude_files = "Classes/Exclude"
  
  s.dependency "AFNetworking", "~> 3.1.0"

end
