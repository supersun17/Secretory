# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/supersun17/Cocoapods_specs.git'

def available_pods
	# Pods for com.MingSun.Secretory
	pod 'RealmSwift', '~> 3.10'
	pod 'ObjectMapper', '~> 3.3'
	pod 'Alamofire'
	pod 'UI_StickersStack', '~> 0.0.3'
end

target 'com.MingSun.Secretory' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  available_pods

  target 'com.MingSun.SecretoryTests' do
    inherit! :search_paths
  end

end
