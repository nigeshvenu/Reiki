# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Reiki' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Reiki
pod 'IQKeyboardManagerSwift'
pod 'SwiftyAttributes'
pod 'NotificationBannerSwift', '~> 3.0.0'
pod 'Alamofire'
pod 'AlamofireImage'
pod 'SideMenu'
pod 'TOCropViewController'
pod "FlagPhoneNumber"
pod 'lottie-ios'
pod 'FSCalendar'
pod 'Switches'
pod 'Lightbox'
pod 'Firebase/Messaging'

end

post_install do |installer|
   installer.pods_project.targets.each do |target|
     target.build_configurations.each do |config|
       xcconfig_path = config.base_configuration_reference.real_path
       xcconfig = File.read(xcconfig_path)
       xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
       File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
     end
   end

   installer.pods_project.targets.each do |target|
     target.build_configurations.each do |config|
       config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
     end
   end
 end
