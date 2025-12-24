# zenohc.podspec
Pod::Spec.new do |s|
  s.name             = 'zenohc'
  s.version          = '1.0.0'
  s.summary          = 'Zenoh C library for iOS'
  s.description      = 'Zenoh C library xcframework for iOS platform'
  s.homepage         = 'https://github.com/VitaDynamics/zenohc-apple.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Your Name' => 'your@email.com' }
  s.source           = { :git => 'https://github.com/VitaDynamics/zenohc-apple.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '13.0'
  s.vendored_frameworks = 'zenohc.xcframework'
  
  # 如果需要链接系统库
  # s.libraries = 'c++'
  # s.frameworks = 'Foundation'
end