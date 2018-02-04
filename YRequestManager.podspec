

Pod::Spec.new do |s|

  s.name         = "YRequestManager"
  s.version      = "1.0.2"
  s.summary      = "Network Request Manager Base IOS AFNetworking Framework "
  s.description  = <<-DESC
                          基于AFNetworking作为网络请求核心（升级版本），封装的一个网络请求框架。说描述信息不能比概述少,说描述信息不能比概述少,说描述信息不能比概述少,说描述信息不能比概述少,说描述信息不能比概述少,说描述信息不能比概述少,说描述信息不能比概述少,说描述信息不能比概述少,说描述信息不能比概述少,说描述信息不能比概述少,说描述信息不能比概述少,说描述信息不能比概述少,说描述信息不能比概述少,说描述信息不能比概述少,说描述信息不能比概述少.
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
