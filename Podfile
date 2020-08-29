# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'DailyGit' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    # Pods for DailyGit
    pod 'SnapKit', '~> 5.0.0'
    pod 'QuickTableViewController'
    pod 'JGProgressHUD'
    pod 'Firebase/Analytics'
#    pod 'Firebase/Performance'
#    pod 'SwiftTrace'
    pod 'Firebase/Messaging'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.name == 'Debug'
        config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
      end
    end
  end
end
