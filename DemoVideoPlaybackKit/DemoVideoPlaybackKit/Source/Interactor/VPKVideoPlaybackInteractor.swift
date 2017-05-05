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

    internal var onVideoPlayerLoadSuccess: LayerClosure?
    
    func didTapVideo(videoURL: URL) {
        playbackManager?.didSelectVideoUrl(videoURL)
       
        playbackManager?.onPlayerLayerClosure = { [weak self] (playerLayer) in
            self?.presenter?.onVideoLoadSuccess(playerLayer)
        }
        
        playbackManager?.onStartPlayingClosure = { [weak self] () in
            self?.presenter?.onVideoDidStartPlaying()
        }
        
        playbackManager?.onStopPlayingClosure = { [weak self] () in
            self?.presenter?.onVideoDidStopPlaying()
        }
        
        playbackManager?.onDidPlayToEndClosure = { [weak self] () in
            self?.presenter?.onVideoDidPlayToEnd()
        }
    }
    
    func didScrub() {
                
    }
    
    func didToggleViewExpansion() {
        
    }
    
    func didMoveOffScreen() {
        playbackManager?.didMoveOffScreen()
    }
}
