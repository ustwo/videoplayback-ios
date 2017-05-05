//
//  VideoViewAnimator.swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 5/4/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation


//MARK: Animator
struct VideoViewAnimator {
    
    static func animateToFullScreen(_ videoView: VPKVideoView) {
        videoView.clipsToBounds = true 
        videoView.goFullscreen()
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


extension CGAffineTransform {
    
    static let ninetyDegreeRotation = CGAffineTransform(rotationAngle: CGFloat(M_PI / 2))
}

extension UIView {
    
    var fullScreenAnimationDuration: TimeInterval {
        return 0.15
    }
    
    func minimizeToFrame(_ frame: CGRect) {
        UIView.animate(withDuration: fullScreenAnimationDuration) {
            self.layer.setAffineTransform(.identity)
            self.frame = frame
        }
    }
    
    func goFullscreen() {
        UIView.animate(withDuration: fullScreenAnimationDuration) {
            self.layer.setAffineTransform(.ninetyDegreeRotation)
            self.frame = UIScreen.main.bounds
        }
    }
}
