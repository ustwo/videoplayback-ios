//
//  MockVideoPlaybackManager.swift
//  VideoPlaybackKit
//
//  Created by Shagun Madhikarmi on 20/09/2017.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
@testable import VideoPlaybackKit

final class MockVideoPlaybackManager: VPKVideoPlaybackManagerInputProtocol, VPKVideoPlaybackManagerOutputProtocol, VPKVideoPlaybackManagerProtocol {
    
    var stubDidSelectVideoUrlIsCalled = false
    var spyDidSelectVideoUrl: URL?

    
    // MARK: - VPKVideoPlaybackManagerInputProtocol
    
    func didSelectVideoUrl(_ url: URL) {
        
        stubDidSelectVideoUrlIsCalled = true
        spyDidSelectVideoUrl = url
    }
    
    func didMoveOffScreen() {
        
        // TODO: (SM) stub this
    }
    
    func didScrubTo(_ seconds: TimeInterval) {
    
        // TODO: (SM) stub this
    }
    
    func didReuseInVideoCell() {
    
        // TODO: (SM) stub this
    }
    
    
    // MARK: - VPKVideoPlaybackManagerOutputProtocol
    
    var onPlayerLayerClosure: LayerClosure?
    var onStartPlayingWithDurationClosure: StartWithDurationClosure?
    var onStopPlayingClosure: CompletionClosure?
    var onDidPlayToEndClosure: CompletionClosure?
    var onTimeDidChangeClosure: TimeClosure?
    
    
    // MARK: - VPKVideoPlaybackManagerProtocol
    
    var playerState: PlayerState?
    var currentVideoUrl: URL?
    var delegate: VPKVideoPlaybackDelegate?
    var isPlaying: Bool { return true }
    
    func stop() { }
    func cleanup() { }
}
