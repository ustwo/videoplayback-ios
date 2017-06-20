//
//  VPKPlayerDelegate.swift
//  VideoPlaybackKit
//
//  Created by Sonam on 4/21/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation


protocol VPKVideoPlaybackDelegate: class {
    
    func playbackManager(_: VPKVideoPlaybackManager, didPreparePlayerLayer playerLayer: AVPlayerLayer)
    func playbackManager(_: VPKVideoPlaybackManager, didStartPlayingWithDuration duration: TimeInterval)
    func playbackManagerDidStopPlaying(_: VPKVideoPlaybackManager)
    func playbackManagerDidPlayToEnd(_: VPKVideoPlaybackManager)
    func playbackManager(_: VPKVideoPlaybackManager, didChangePlayingTime time: TimeInterval)
    func playbackManager(_: VPKVideoPlaybackManager, didFailWithError error: Error)
    func playbackManagerDidPlayNewVideo(_: VPKVideoPlaybackManager)
}

