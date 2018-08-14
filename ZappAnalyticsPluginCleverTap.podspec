Pod::Spec.new do |s|

    s.name             = "ZappAnalyticsPluginCleverTap"
    s.version          = '4.0.0'
    s.summary          = "ZappAnalyticsPluginCleverTap analytics plugin for Zapp iOS."
    s.description      = <<-DESC
                          ZappAnalyticsPluginCleverTap analytics plugin for Zapp iOS.
                         DESC
    s.homepage         = "https://github.com/applicaster/ZappAnalyticsPluginCleverTap"
    s.license          = 'MIT'
    s.author           = { "Roi Kedarya" => "Roi Kedarya" }
    s.source           = { :git => "git@github.com:applicaster/ZappAnalyticsPluginCleverTap.git", :tag => s.version.to_s }
  
    s.ios.deployment_target  = "9.0"
    s.platform     = :ios, '9.0'
    s.requires_arc = true
    s.swift_version = '4.1'

    s.subspec 'Core' do |c|
      s.resources = []
      c.frameworks = 'UIKit','CoreTelephony','Security','SystemConfiguration','CleverTapSDK'
      c.source_files = 'PluginClasses/*.{swift,h,m}'
      c.dependency 'ZappPlugins'
      c.dependency 'ApplicasterSDK'
      c.dependency 'CleverTap-iOS-SDK'
    end
                  
    s.xcconfig =  { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                    'ENABLE_BITCODE' => 'YES',
                    'OTHER_LDFLAGS' => '$(inherited)',
                    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}"/**',
                    'LIBRARY_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}"/**',
                    'SWIFT_VERSION' => '4.1'
                  }
                  
    s.default_subspec = 'Core'
                  
  end
  
