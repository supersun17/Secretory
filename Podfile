# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

def available_pods
	# Pods for com.MingSun.Secretory
	pod 'RealmSwift', '~> 3.10'
	pod 'ObjectMapper', '~> 3.3'
	pod 'Alamofire'
end

target 'com.MingSun.Secretory' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  available_pods

  target 'com.MingSun.SecretoryTests' do
    inherit! :search_paths
  end

end
