//
//  VPKVideoPlayerInteractor.swift
//  VideoPlaybackKit
//
//  Created by Sonam on 4/24/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation


public class VPKVideoPlaybackInteractor: VPKVideoPlaybackInteractorInputProtocol {

    
    var playbackManager: (VPKVideoPlaybackManagerInputProtocol & VPKVideoPlaybackManagerOutputProtocol & VPKVideoPlaybackManagerProtocol)?
    weak var presenter: VPKVideoPlaybackInteractorOutputProtocol?
    

    func didTapVideo(videoURL: URL, at indexPath: NSIndexPath? = nil) {
        playbackManager?.didSelectVideoUrl(videoURL)        
        playbackManager?.delegate = self
    }
    
    func didReuseInCell() {
        playbackManager?.didReuseInVideoCell()
    }
    
    func didScrubTo(_ timeInSeconds: TimeInterval) {
        playbackManager?.didScrubTo(timeInSeconds)                
    }
    
    func didSkipBack(_ seconds: Float) {
    
    }
    
    func didSkipForward(_ seconds: Float) {
        
    }
    
    func didToggleViewExpansion() {
        
    }
    
    func didMoveOffScreen() {
        playbackManager?.didMoveOffScreen()
    }
}

extension VPKVideoPlaybackInteractor: VPKVideoPlaybackDelegate {
    
    func playbackManagerDidPlayNewVideo(_: VPKVideoPlaybackManager) {
        presenter?.onVideoResetPresentation()
    }
    
    func playbackManager(_: VPKVideoPlaybackManager, didPrepare playerLayer: AVPlayerLayer) {
        presenter?.onVideoLoadSuccess(playerLayer)
    }
    
    func playbackManager(_: VPKVideoPlaybackManager, didStartPlayingWith duration: TimeInterval) {
        presenter?.onVideoDidStartPlayingWith(duration)
    }

    
    func playbackManager(_: VPKVideoPlaybackManager, didChange time: TimeInterval) {
        presenter?.onVideoPlayingFor(time)
    }
    
    func playbackManager(_: VPKVideoPlaybackManager, didFailWith error: Error) {
        //TODO::::
    }
    
    func playbackManagerDidStopPlaying(_: VPKVideoPlaybackManager) {
        presenter?.onVideoDidStopPlaying()
    }
    
    func playbackManagerDidPlayToEnd(_: VPKVideoPlaybackManager) {
        presenter?.onVideoDidPlayToEnd()
    }
}
