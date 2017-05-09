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
    
    private var fullScreenAnimationDuration: TimeInterval {
        return 0.15
    }
    
    static func animateToFullScreen<T: UIView>(_ videoView: T) where T: VPKVideoViewProtocol {
        videoView.fullScreenMode()
    }
    
    static func animateToNormalScreen(_ videoView: VPKVideoViewProtocol) {
        
    }
    
    
    /*func minimizeToFrame(_ frame: CGRect) {
        UIView.animate(withDuration: fullScreenAnimationDuration) {
            self.layer.setAffineTransform(.identity)
            self.frame = frame
        }
    }*/
    
    static func animateVideoPlayerView(_ videoView: VPKVideoView, fromState initialState: PlayerState, toState finalState: PlayerState, withCompletion completion: CompletionClosure?) {
    }
}

//TODO: CLEAN UP
extension VPKVideoViewProtocol where Self: UIView {
    
    func fullScreenMode() {
        guard  let window = UIApplication.shared.delegate?.window,
            let safePlayerLayer = self.playerLayer else { return }
        
        window?.addSubview(self)
        var sx: CGFloat = 0
        var sy: CGFloat = 0
        
        if self.frame.size.width > self.frame.size.height {
            sx = self.frame.size.width/safePlayerLayer.frame.size.width
            safePlayerLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(scaleX: sx, y: sy))
        } else {
            sy = self.frame.size.height/safePlayerLayer.frame.size.height
            safePlayerLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(scaleX: sx, y: sy))
        }
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            safePlayerLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(scaleX: sx, y: sy))
        })
    }
}

extension CGAffineTransform {
    
    static let ninetyDegreeRotation = CGAffineTransform(rotationAngle: CGFloat(M_PI / 2))
}
