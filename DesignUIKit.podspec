#
#  Be sure to run `pod spec lint Components.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name = "DesignUIKit"
  s.version = '0.0.1'
  s.homepage = "https://github.com"

  s.authors = { 'Duc Nguyen' => 'ducnguyen6431@outlook.com' }
  s.source = { :git => 'https://bitbucket.org/dn6431/componentsystem.git', :tag => s.version }
  s.summary = 'Are you tired of repeative actions? This framework might be your solution!'

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.license = { :type => 'MIT' }
  s.default_subspec = 'UI'
  
  # Subspecs zone
  s.subspec 'UI' do |ss|
    ss.source_files = 'Sources/UIKit/**/*.{swift}'
    ss.exclude_files = 'Sources/UIKit/Archived/**/*.{swift}'
    ss.dependency 'DesignCore'
    ss.dependency 'DesignExts'
    ss.dependency 'DesignExternal'
    ss.dependency 'Nuke'
    ss.dependency 'SnapKit'
  end
end
