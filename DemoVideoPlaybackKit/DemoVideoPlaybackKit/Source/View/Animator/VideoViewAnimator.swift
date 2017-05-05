//
//  VideoViewAnimator.swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 5/4/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import UIKit


//MARK: Animator
struct VideoViewAnimator {
    
    static func animateToFullScreen(_ videoView: VPKVideoView) {
        videoView.clipsToBounds = false
        let layer = videoView.layer
        let oldBounds = layer.bounds
        var newBounds = oldBounds
        newBounds.size = UIScreen.main.bounds.size
        
        //Ensure at the end of animation, you have proper bounds
        layer.bounds = newBounds

        let boundsAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnimation.fromValue = oldBounds
        boundsAnimation.toValue = newBounds
        boundsAnimation.duration = 30
    }
    
    static func animateVideoPlayerView(_ videoView: VPKVideoView, fromState initialState: PlayerState, toState finalState: PlayerState, withCompletion completion: CompletionClosure?) {
        
        /*switch (initialState, finalState) {
        case (.playing, .paused) where videoView.activityIndicator.isAnimating == false:
            DispatchQueue.main.async {
                videoView.playButton.toggle(state: finalState)
                videoView.playButton.layer.zPosition = LayerHierachy.top.rawValue
                videoView.playButton.fadeIn(time: 0.3, completion: {
                    completion?()
                })
            }
        case (.paused, .playing):
            videoView.playButton.fadeOutPulse(time: 0.3, completion: {
                videoView.activityIndicator.startAnimating()
                completion?()
            })
        default:
            break
        }*/
    }
}
