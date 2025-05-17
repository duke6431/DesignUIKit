#
#  Be sure to run `pod spec lint Components.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name = "DesignUIKit"
  s.version = '1.0.1'
  s.homepage = "https://github.com/duke6431/DesignUIKit"

  s.authors = { 'Duke Nguyen' => 'ducnguyen6431@outlook.com' }
  s.source = { :git => 'https://github.com/duke6431/DesignUIKit.git', :tag => s.version }
  s.summary = 'A modular Swift UI framework to reduce repetitive work across UIKit apps.'

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.license = { :type => 'MIT' }

  # No default_subspec to allow opt-in modular install
  s.default_subspec = nil

  # Core module
  s.subspec 'DesignCore' do |core|
    core.source_files = 'Sources/Core/**/*.{swift}'
    core.exclude_files = 'Sources/Core/Archived/**/*.{swift}'
    core.dependency 'Logging'
    core.dependency 'FileKit'
    core.resource_bundles = {
      'DesignCore_Privacy' => ['Sources/DesignCore/PrivacyInfo.xcprivacy']
    }
  end

  # Extensions module
  s.subspec 'DesignExts' do |exts|
    exts.source_files = 'Sources/Exts/**/*.{swift}'
    exts.exclude_files = 'Sources/Exts/Archived/**/*.{swift}'
    exts.dependency 'DesignKit/DesignCore'
    exts.resource_bundles = {
      'DesignExts_Privacy' => ['Sources/DesignExts/PrivacyInfo.xcprivacy']
    }
  end

  # External integrations module
  s.subspec 'DesignExternal' do |external|
    external.source_files = 'Sources/ExternalPackages/**/*.{swift}'
    external.exclude_files = 'Sources/ExternalPackages/Archived/**/*.{swift}'
    external.dependency 'FileKit'
    external.resource_bundles = {
      'DesignExternal_Privacy' => ['Sources/DesignExternal/PrivacyInfo.xcprivacy']
    }
  end

  # UIKit module
  s.subspec 'DesignUIKit' do |ui|
    ui.source_files = 'Sources/UIKit/**/*.{swift}'
    ui.exclude_files = 'Sources/UIKit/Archived/**/*.{swift}'
    ui.dependency 'DesignKit/DesignCore'
    ui.dependency 'DesignKit/DesignExts'
    ui.dependency 'DesignKit/DesignExternal'
    ui.dependency 'SnapKit'
    ui.dependency 'Nuke'
    ui.resource_bundles = {
      'DesignUIKit_Privacy' => ['Sources/DesignUIKit/PrivacyInfo.xcprivacy']
    }
  end

  # RxSwift support
  s.subspec 'DesignRxUIKit' do |rx|
    rx.source_files = 'Sources/UIKit+Rx/**/*.{swift}'
    rx.exclude_files = 'Sources/UIKit+Rx/Archived/**/*.{swift}'
    rx.dependency 'DesignKit/DesignUIKit'
    rx.dependency 'RxSwift'
    rx.dependency 'RxCocoa'
    rx.resource_bundles = {
      'DesignRxUIKit_Privacy' => ['Sources/DesignRxUIKit/PrivacyInfo.xcprivacy']
    }
  end
end
