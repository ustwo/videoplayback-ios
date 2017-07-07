Pod::Spec.new do |spec|
  spec.name = "VideoPlaybackKit"
  spec.version = "0.0.3"
  spec.summary = "Using Swift and the VIP pattern this is a module built using AVPlayer to return video views"
  spec.homepage = "https://github.com/ustwo/videoplayback-ios"
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.authors = {
    "Sonam Dhingra" => 'sonam@ustwo.com',
    "thoughtbot" => nil,
  }

  spec.source = { :git => "https://github.com/ustwo/videoplayback-ios.git", :tag => "v#{spec.version}", :submodules => true }
  spec.source_files  ="VideoPlaybackKit/VideoPlaybackKit/*"
  spec.requires_arc = true
  spec.platform     = :ios, "10.0"
  
  spec.ios.deployment_target = "8.0"
  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }
  
 spec.dependency "ASValueTrackingSlider"
 spec.dependency 'Alamofire', '~> 4.4'
 spec.dependency 'AlamofireImage', '~> 3.1'
 spec.dependency 'SnapKit', '~> 3.2.0'
 
end