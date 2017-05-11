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
import RxSwift


public class VPKVideoPlaybackInteractor: VPKVideoPlaybackInteractorInputProtocol {
    
    var playbackManager: (VPKVideoPlaybackManagerInputProtocol & VPKVideoPlaybackManagerOutputProtocol)?
    weak var presenter: VPKVideoPlaybackInteractorOutputProtocol?
    
    func didTapVideo(videoURL: URL) {
        playbackManager?.didSelectVideoUrl(videoURL)
       
        playbackManager?.onPlayerLayerClosure = { [weak self] (playerLayer) in
            self?.presenter?.onVideoLoadSuccess(playerLayer)
        }
        
        playbackManager?.onStartPlayingWithDurationClosure = { [weak self] (duration) in
            self?.presenter?.onVideoDidStartPlayingWith(duration)
        }
        
        playbackManager?.onStopPlayingClosure = { [weak self] () in
            self?.presenter?.onVideoDidStopPlaying()
        }
        
        playbackManager?.onDidPlayToEndClosure = { [weak self] () in
            self?.presenter?.onVideoDidPlayToEnd()
        }
        
        playbackManager?.onTimeDidChangeClosure = { [weak self] (time) in
            self?.presenter?.onVideoPlayingFor(time)
        }
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
