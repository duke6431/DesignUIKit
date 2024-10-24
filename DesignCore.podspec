#
#  Be sure to run `pod spec lint Components.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name = "DesignCore"
  s.version = '0.0.1'
  s.homepage = "https://github.com"

  s.authors = { 'Duc Nguyen' => 'ducnguyen6431@outlook.com' }
  s.source = { :git => 'https://github.com', :tag => s.version }
  s.summary = 'Are you tired of repeative actions? This framework might be your solution!'

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.license = { :type => 'MIT' }
  s.default_subspec = 'Core'
  
  # Subspecs zone
  s.subspec 'Core' do |ss|
    ss.source_files = 'Sources/Core/**/*.{swift}'
    ss.exclude_files = 'Sources/Core/Archived/**/*.{swift}'

    ss.dependency("Logging")
  end
end
