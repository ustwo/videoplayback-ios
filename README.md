<p align="center" >
<img src="Images/VPKPlayback_logo.png" title="VPKVideoPlayer logo" float=left>
</p>

[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/ustwo/videoplayback-ios)
[![pod](https://img.shields.io/badge/pod-0.2.2-green.svg)](https://github.com/ustwo/videoplayback-ios) 
[![pod](https://img.shields.io/badge/swift-support-fc2f24.svg?maxAge=2592000)](https://github.com/apple/swift)


## Summary 

This framework is built using the VIPER (modified to VIPE) architecture. It started as an experiment with the architecture itself and is now a work in progress.

It is a swift wrapper around the AVFoundation framework. Use it to play remote, or local videos in a simple view or feed. Its purpose is to make playing progressive downloads and live streams simpler in your iOS applications

## Disclaimer:

This framework is a work in progress. Unit tests, VIPE refactoring, and bug fixes are pending. 

## Features

- [x] Scrub Video 
- [x] Handle play or stop video in main thread
- [x] Play in UITableView 
- [x] Autoplay video    
- [x] HTTPS support
- [x] Written in Swift 
- [x] Landscape support
- [x] Cocoapod support 

## Requirements

- iOS 10.0 or later
- Xcode 8.3 or later

## Getting Started

- Go to the "DemoVideoPlaybackKit" folder, run pod install. Open the workspace and build 


## About

The VIPER architecture has been talked about in the iOS community; however, it is uncommonly used. We wanted to gain an in depth understanding of this design pattern and see what the buzz was all about. As a result, we decided to test the following hypothesis: 

> As a developer I would like to use the VIPER design pattern to build reusable modules


We then decided to experiment with VIPER & playing video content. Playing video involves UI updates, data downloading & data syncrhonization. These complexities & interactions proved themselves to be worthwhile candidate for a VIPER structured module. 

## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.


## Installation

- pod install 'VideoPlaybackKit'

## How To Use

```swift 
import VideoPlaybackKit
```

### Play a single video in a view - add a single view to your screen which contains video content

<img src="Images/single_video.gif" title="Single Video" float=left>

 

1. Define the Video Type (local or remote). This is the ENTITY represented in the VIPER structure

```swift 
let videoType = VPKVideoType.local(videoPathName: "Elon_Musk", fileType: "mp4", placeholderImageName: "elon_1")
```

2. Build the video view 

```swift
VPKVideoPlaybackBuilder.vpk_buildVideoView(for: videoType, shouldAutoplay: self.shouldAutoPlay, playbackBarTheme: self.toolBarTheme) { [weak self] (videoView) in

        self?.view.addSubview(videoView)
        videoView.snp.makeConstraints({ (make) in
        make.height.equalTo(self?.view.snp.height).dividedBy(2)
        make.top.equalTo(self?.view.snp.top).offset(10)
        make.left.right.equalTo(self?.view)
    })
}
```

### Play a video in a feed

<img src="Images/video_feed.gif" title="Video Feed" float=left>

1. Create a UITabieViewCell that conforms to VPKViewInCellProtocol

```swift 
class VideoTableViewCell: UITableViewCell, VPKViewInCellProtocol {
    static let identifier = "VideoCell"
    var videoView: VPKVideoView? {
        didSet {
            self.setupVideoViewConstraints()
            layoutIfNeeded()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepareForVideoReuse() //Extension default
    }
}
```

2. Register cell in UIViewController, set up tableview. Add videoview to cell 
 

```swift 
    tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: VideoTableViewCell.identifier)
    tableView.estimatedRowHeight = 400
    tableView.rowHeight = UITableViewAutomaticDimension

    datasource.asObservable().bind(to: tableView.rx.items(cellIdentifier: VideoTableViewCell.identifier)) { index, model, cell in
            
        guard let cell = cell as? VideoTableViewCell else { return }

        VPKVideoPlaybackBuilder.vpk_buildViewInCell(for: model, at: NSIndexPath(item: index, section: 0), completion: { [weak self] (videoView) in
                cell.videoView = videoView
                cell.layoutIfNeeded()
        })}.addDisposableTo(disposeBag)

        tableView.rx.setDelegate(self)
}
```

### Autoplay Videos in a feed

1. Conform to the VPKTableViewVideoPlaybackScrollable protocol 

Implement the following: 

```swift 
extension FeedViewController: VPKTableViewVideoPlaybackScrollable {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleAutoplayInTopVideoCell() // default implementation
        trackVideoViewCellScrolling() // default implementation
    }   

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if shouldAutoplayVideos {
            handleAutoplayInTopVideoCell()
        }
    }
}
```

### Play video in feed, pre-fetch video asset data. *** Recommended especially for auto playing video in a feed ***

1. Create a VPKTableViewPrefetchSynchronizer object 

```swift 
videoPrefetcher = VPKTableViewPrefetchSynchronizer(videoItems: datasource.value)
```

2. Conform to the UITableViewDataSourcePrefetching tableview protocool 

```swift 

tableView.prefetchDataSource = self

extension FeedViewController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        videoPrefetcher?.tableView(tableView, prefetchRowsAt: indexPaths)
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        videoPrefetcher?.tableView(tableView, cancelPrefetchingForRowsAt: indexPaths)
    }
}
```


## Contact：
- Email: sonam@ustwo.com

<img src="Images/snake.png" title="Snake Body" float=left>
