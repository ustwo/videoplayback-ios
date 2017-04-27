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


public class VPKVideoPlayerInteractor: NSObject {
    
    fileprivate var manager = VPKVideoPlayerManager()
    internal var onVideoLoadSuccess: LayerClosure?
    
    override init() {
        super.init()
        manager.playerLayerClosure = { (playerLayer) in
            self.onVideoLoadSuccess(playerLayer)
        }
    }
 
}

extension VPKVideoPlayerInteractor: VPKVideoPlayerInteractorInput {
   
    func didTapVideo(videoURL: URL) {
        manager.didSelectVideoUrl(videoURL)
    }
    
    func didScrub() {
                
    }
    
    func didToggleViewExpansion() {
        
    }
    
    func didMoveOffScreen() {
        manager.didMoveOffScreen()
    }
}


extension VPKVideoPlayerInteractor: VPKVideoPlayerInteractorOutput {
    
    func onVideoLoadSuccess(_ playerLayer: AVPlayerLayer) {
        self.onVideoLoadSuccess?(playerLayer)
    }
    
    func onVideoLoadFail(_ error: String) {
        
    }
    
    func onStateChange(_ startState: PlayerState, to endState: PlayerState) {
        
    }
}
