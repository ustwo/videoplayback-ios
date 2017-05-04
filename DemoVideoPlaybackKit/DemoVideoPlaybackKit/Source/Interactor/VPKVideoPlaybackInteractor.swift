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
    var presenter: VPKVideoPlaybackInteractorOutputProtocol?

    internal var onVideoPlayerLoadSuccess: LayerClosure?
    
    func didTapVideo(videoURL: URL) {
        playbackManager?.didSelectVideoUrl(videoURL)
        playbackManager?.onPlayerLayerClosure = { (playerLayer) in
            self.onVideoLoadSuccess(playerLayer)
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


//Output
extension VPKVideoPlaybackInteractor: VPKVideoPlaybackInteractorOutputProtocol {
    
    func onVideoLoadSuccess(_ playerLayer: AVPlayerLayer) {
        presenter?.onVideoLoadSuccess(playerLayer)
    }
    
    func onVideoLoadFail(_ error: String) {
        presenter?.onVideoLoadFail(error)
    }
    
    func onStateChange(_ startState: PlayerState, to endState: PlayerState) {
        
    }
}
