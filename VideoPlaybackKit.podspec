Pod::Spec.new do |spec|
  spec.name = "VideoPlaybackKit"
  spec.version = "1.0.0"
  spec.summary = "Reusable AVPlayer video player wrapper iOS componnent"
  spec.homepage = "https://github.com/ustwo/videoplayback-ios"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Sonam Dhingra" => 'sonam@ustwo.com' }
  spec.platform = :ios, "10.1"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/ustwo/videoplayback-ios", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "VideoPlaybackKit/**/*.{h,swift}"
end
