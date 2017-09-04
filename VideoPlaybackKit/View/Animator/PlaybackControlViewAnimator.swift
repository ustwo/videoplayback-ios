//
//  PlaybackControlViewAnimator.swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 8/18/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import UIKit


//MARK: Animator

struct PlaybackControlViewAnimator {
    

    static func fadeOut(_ playbackControlView: VPKPlaybackControlViewProtocol) {

        guard let controlView = playbackControlView as? UIView else {
            assertionFailure("control view is not a UIView")
            return
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                controlView.alpha = 0.0
                controlView.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    static func fadeIn(_ playbackControlView: VPKPlaybackControlViewProtocol) {
        
        guard let controlView = playbackControlView as? UIView else {
            assertionFailure("control view is not a UIView")
            return
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                controlView.alpha = 1.0
                controlView.layoutIfNeeded()
            }, completion: nil)
        }
    }
}
