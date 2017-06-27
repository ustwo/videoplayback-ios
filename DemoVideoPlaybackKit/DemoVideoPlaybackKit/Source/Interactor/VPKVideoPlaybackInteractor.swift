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
    
    func playbackManager(_: VPKVideoPlaybackManager, didPreparePlayerLayer playerLayer: AVPlayerLayer) {
        presenter?.onVideoLoadSuccess(playerLayer)
    }
    
    
    func playbackManager(_: VPKVideoPlaybackManager, didStartPlayingWithDuration duration: TimeInterval) {
        presenter?.onVideoDidStartPlayingWith(duration)
    }
    
    func playbackManager(_: VPKVideoPlaybackManager, didChangePlayingTime time: TimeInterval) {
        presenter?.onVideoPlayingFor(time)
    }
    
    func playbackManager(_: VPKVideoPlaybackManager, didFailWithError error: Error) {
        //TODO::::
    }
    
    func playbackManagerDidStopPlaying(_: VPKVideoPlaybackManager) {
        presenter?.onVideoDidStopPlaying()
    }
    
    func playbackManagerDidPlayToEnd(_: VPKVideoPlaybackManager) {
        presenter?.onVideoDidPlayToEnd()
    }
}
