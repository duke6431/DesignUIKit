#
#  Be sure to run `pod spec lint Components.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name = "DesignExts"
  s.version = '1.0.0'
  s.homepage = "https://github.com/duke6431/DesignUIKit"

  s.authors = { 'Duc Nguyen' => 'ducnguyen6431@outlook.com' }
  s.source = { :git => 'https://github.com/duke6431/DesignUIKit.git', :tag => s.version }
  s.summary = 'Are you tired of repeative actions? This framework might be your solution!'

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.license = { :type => 'MIT' }
  s.default_subspec = 'Exts'
  s.resource_bundles = {
    'DesignExts_Privacy' => ['Sources/DesignExts/PrivacyInfo.xcprivacy'],
  }
  # Subspecs zone
  s.subspec 'Exts' do |ss|
    ss.source_files = 'Sources/Exts/**/*.{swift}'
    ss.exclude_files = 'Sources/Exts/Archived/**/*.{swift}'
    ss.dependency 'DesignCore'
  end
end
