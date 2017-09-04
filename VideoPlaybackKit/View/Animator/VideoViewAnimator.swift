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
import SnapKit


//MARK: Animator
struct VideoViewAnimator {
    
    fileprivate var originalVideoViewRect = CGRect.zero
    
    private var fullScreenAnimationDuration: TimeInterval {
        return 0.15
    }
    
    static func animateToFullScreen<T: UIView>(_ videoView: T) where T: VPKVideoViewProtocol {

        videoView.fullScreenMode()
    }
    
    static func animateToNormalScreen<T: UIView>(_ videoView: T) where T: VPKVideoViewProtocol {
        videoView.normalScreenMode()
    }
    
    static func animateVideoPlayerView(_ videoView: VPKVideoView, fromState initialState: PlayerState, toState finalState: PlayerState, withCompletion completion: CompletionClosure?) {
    }
}


//TODO: CLEAN UP
extension VPKVideoViewProtocol where Self: UIView {
    
    func normalScreenMode() {
        #if DEBUG
            print("collapsing into original screen")
        #endif
        
        guard   let sourceFrame = originalFrame,
                let appDelagate = UIApplication.shared.delegate,
                let safeWindow = appDelagate.window else { return }

        #if DEBUG
            print("source frame \(sourceFrame)")
        #endif
        
        fullScreenBGView.isHidden = true // no longer need to view background view
        originalSuperview.addSubview(self) // re-add it to the original superview
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .beginFromCurrentState, animations: {
            self.snp.remakeConstraints { (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.top.equalTo(sourceFrame.origin.y)
                make.centerX.equalTo(sourceFrame.midX)
                make.centerY.equalTo(sourceFrame.midY)
            }
            self.layoutIfNeeded()
        }) {(completed) in
            safeWindow!.windowLevel = UIWindowLevelNormal
        }
    }
    
    func fullScreenMode() {
        #if DEBUG
            print("expanding into full screen")
         #endif
        
        guard   let appDelagate = UIApplication.shared.delegate,
                let safeWindow = appDelagate.window,
                let safeSuperView = self.superview else { return }
        
        self.originalFrame = self.frame //Set original frame before changing it
        self.originalSuperview = safeSuperView // Hold on the the original superview
        
        fullScreenBGView.isHidden = false //show the black background view
        
        safeWindow!.addSubview(self) // add the view to the window
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .beginFromCurrentState, animations: {
            self.snp.remakeConstraints { (make) in
                make.edges.equalTo(safeWindow!)
            }
            self.layoutIfNeeded()
        }) { (completed) in
            safeWindow!.windowLevel = UIWindowLevelStatusBar
        }
    }
}
