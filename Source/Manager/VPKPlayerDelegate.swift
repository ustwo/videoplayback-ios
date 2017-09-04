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
    
    func playbackManager(_: VPKVideoPlaybackManager, didPrepare playerLayer: AVPlayerLayer)
    func playbackManager(_: VPKVideoPlaybackManager, didStartPlayingWith duration: TimeInterval)
    func playbackManagerDidStopPlaying(_: VPKVideoPlaybackManager)
    func playbackManagerDidPlayToEnd(_: VPKVideoPlaybackManager)
    func playbackManager(_: VPKVideoPlaybackManager, didChange time: TimeInterval)
    func playbackManager(_: VPKVideoPlaybackManager, didFailWith error: Error)
    func playbackManagerDidPlayNewVideo(_: VPKVideoPlaybackManager)
}

