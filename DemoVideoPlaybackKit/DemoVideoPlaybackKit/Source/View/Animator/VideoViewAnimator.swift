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
    
    static func animateVideoPlayerView(_ videoView: VPKVideoView, fromState initialState: PlayerState, toState finalState: PlayerState, withCompletion completion: CompletionClosure?) {
        
    }
}

//TODO: CLEAN UP
extension VPKVideoViewProtocol where Self: UIView {
    
    func fullScreenMode() {
        print("Animating to full screen")
        
        guard   let appDelagate = UIApplication.shared.delegate,
                let safeWindow = appDelagate.window,
                let windowSize = safeWindow?.frame.size, self.playerLayer != nil else { return }
    
        let bgView = UIView(frame: .zero)
        safeWindow?.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        bgView.backgroundColor = .black
        bgView.addSubview(self)
        
        switch UIDevice.current.orientation {
        case .portrait:
            UIView.animate(withDuration: 0.5, animations: { 
                self.snp.remakeConstraints({ (make) in
                    make.edges.equalToSuperview()
                })
                self.resize(self.playerLayer!, to: windowSize)
                self.layoutIfNeeded()
            }, completion: nil)
        case .landscapeLeft, .landscapeRight:
            UIView.animate(withDuration: 0.5, animations: {
                self.snp.remakeConstraints({ (make) in
                    make.edges.equalToSuperview()
                })
                self.resize(self.playerLayer!, to: windowSize)
                self.layoutIfNeeded()
            }, completion: nil)
            
        default:
            break
        }
        
        
    }
    
    
    func resize(_ layer: AVPlayerLayer,to size: CGSize) {
        let oldBounds = layer.bounds
        var newBounds = oldBounds
        newBounds.size = size
        let animation = CABasicAnimation(keyPath: "bounds")
        animation.fromValue = NSValue(cgRect: oldBounds)
        animation.toValue = NSValue(cgRect: newBounds)
        layer.bounds = newBounds
        layer.add(animation, forKey: "bounds")
    }
}

extension CGAffineTransform {
    
    static let ninetyDegreeRotation = CGAffineTransform(rotationAngle: CGFloat(M_PI / 2))
}
