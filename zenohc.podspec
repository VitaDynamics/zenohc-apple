# zenohc.podspec
Pod::Spec.new do |s|
  s.name             = 'zenohc'
  s.version          = '1.7.2'
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

  # CocoaPods links this pod as -lzenohc (expects libzenohc.a). The simulator slice
  # inside the xcframework is named zenohc-sim-universal.a, so we create a symlink
  # in the build intermediates to satisfy the linker.
  s.script_phases = [
    {
      :name => 'zenohc symlink (simulator)',
      :execution_position => :before_compile,
      :shell_path => '/bin/sh',
      :script => <<-'SCRIPT'
set -e
if [ "${PLATFORM_NAME}" = "iphonesimulator" ]; then
  dir="${PODS_XCFRAMEWORKS_BUILD_DIR}/zenohc"
  if [ -f "${dir}/zenohc-sim-universal.a" ] && [ ! -f "${dir}/libzenohc.a" ]; then
    ln -sf "zenohc-sim-universal.a" "${dir}/libzenohc.a"
  fi
fi
SCRIPT
    }
  ]
end