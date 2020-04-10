#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint chinese_character_recognition.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'chinese_character_recognition'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes**/*.h'
  #s.static_framework = true
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  s.vendored_libraries = "**/*.a"
  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS' => 'arm64' }
  s.swift_version = '5.0'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-force_load "${PODS_ROOT}/../.symlinks/plugins/chinese_character_recognition/ios/libhanzi_lookup.a"'}
end
