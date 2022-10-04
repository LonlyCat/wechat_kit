#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint wechat_kit.podspec` to validate before publishing.
#

pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))
library_version = pubspec['version'].gsub('+', '-')

calling_dir = File.dirname(__FILE__)
flutter_project_dir = calling_dir.slice(0..(calling_dir.index('/ios/.symlinks')))
# cfg = YAML.load_file(File.join(File.expand_path('../../../../..', File.dirname(__FILE__)), 'pubspec.yaml'))
cfg = YAML.load_file(File.join(flutter_project_dir, 'pubspec.yaml'))
if cfg['wechat_kit']
    if cfg['wechat_kit']['ios'] == 'no_pay'
        wechat_kit_subspec = 'no_pay'
    else
        wechat_kit_subspec = 'pay'
    end
else
    # 5.x.y 版本将删除
    if defined?($WechatKitSubspec)
      wechat_kit_subspec = $WechatKitSubspec
    else
      wechat_kit_subspec = 'no_pay'
    end
end
Pod::UI.puts "wechatsdk #{wechat_kit_subspec}"

Pod::Spec.new do |s|
  s.name             = 'wechat_kit'
  s.version          = library_version
  s.summary          = 'The Flutter plugin for WeChat SDKs.'
  s.description      = <<-DESC
A powerful Flutter plugin allowing developers to auth/pay/share with native Android & iOS WeChat SDKs.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'mob_sharesdk/ShareSDKPlatforms/WeChat'
  s.platform = :ios, '9.0'

  s.static_framework = true
  # s.default_subspecs = :none
  s.default_subspec = wechat_kit_subspec

  s.subspec 'pay' do |sp|
    # sp.source_files = 'Libraries/OpenSDK1.9.2/*.h'
    # sp.public_header_files = 'Libraries/OpenSDK1.9.2/*.h'
    # sp.vendored_libraries = 'Libraries/OpenSDK1.9.2/*.a'
    sp.frameworks = 'CoreGraphics', 'Security', 'WebKit'
    sp.libraries = 'c++', 'z', 'sqlite3.0'
    sp.pod_target_xcconfig = {
        'OTHER_LDFLAGS' => '$(inherited) -ObjC -all_load',
    }
  end

  s.subspec 'no_pay' do |sp|
    # sp.source_files = 'Libraries/OpenSDK1.9.2_NoPay/*.h'
    # sp.public_header_files = 'Libraries/OpenSDK1.9.2_NoPay/*.h'
    # sp.vendored_libraries = 'Libraries/OpenSDK1.9.2_NoPay/*.a'
    sp.frameworks = 'CoreGraphics', 'Security', 'WebKit'
    sp.libraries = 'c++', 'z', 'sqlite3.0'
    sp.pod_target_xcconfig = {
        'OTHER_LDFLAGS' => '$(inherited) -ObjC -all_load',
        'GCC_PREPROCESSOR_DEFINITIONS' => 'NO_PAY=1'
    }
  end

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
