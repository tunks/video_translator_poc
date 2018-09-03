# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'video_translator_poc' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for video_translator_poc

  target 'video_translator_pocTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'video_translator_pocUITests' do
    inherit! :search_paths
    # Pods for testing
  end

  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
  end

  pod 'VGPlayer', '~> 0.2.0'
  pod 'MarqueeLabel/Swift'
  pod 'iOSDropDown'
  pod 'Eureka'
end
