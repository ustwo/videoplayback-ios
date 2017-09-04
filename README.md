<p align="center" >
<img src="Images/VPKPlayback_logo.png" title="VPKVideoPlayer logo" float=left>
</p>

[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/ustwo/videoplayback-ios)
[![pod](https://img.shields.io/badge/pod-1.0.0-green.svg)](https://github.com/ustwo/videoplayback-ios) 
[![pod](https://img.shields.io/badge/swift-support-fc2f24.svg?maxAge=2592000)](https://github.com/apple/swift)
[![pod](https://img.shields.io/badge/Carthage-support-green.svg)](https://github.com/Carthage/Carthage)


This framework is built using the VIP architecture. It is a wrapper around the AVFoundation framework. Use it to play remote, or local videos in a simple view or feed. Its purpose is to make playing progressive downloads and live streams simpler in your iOS applications

## Features

- [x] Scrub Video 
- [x] Handle play or stop video in main thread
- [x] Play in UITableView 
- [x] Autoplay video    
- [x] HTTPS support
- [x] Live stream support 
- [x] Written in Swift 
- [x] Landscape support
- [x] Cocoapod support 

## Requirements

- iOS 10.0 or later
- Xcode 8.3 or later


## Getting Started

- Try the example by running the Demo project


## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.


## Installation

- pod install VideoPlaybackKit

## How To Use

import VideoPlaybackKit

#### Play a single video in a view 

Single Video view - add a single view to your screen which contains video content 

1. Define the Video Type (local or remote)

let videoType = VPKVideoType.local(videoPathName: "Elon_Musk", fileType: "mp4", placeholderImageName: "elon_1")


2. Build the video view 

VPKVideoPlaybackBuilder.vpk_buildVideoView(for: videoType, shouldAutoplay: self.shouldAutoPlay, playbackBarTheme: self.toolBarTheme) { (videoView) in

    self.view.addSubview(videoView)
    videoView.snp.makeConstraints({ (make) in
    make.height.equalTo(view.snp.height).dividedBy(2)
    make.top.equalTo(view.snp.top).offset(10)
    make.left.right.equalTo(view)
})
}



