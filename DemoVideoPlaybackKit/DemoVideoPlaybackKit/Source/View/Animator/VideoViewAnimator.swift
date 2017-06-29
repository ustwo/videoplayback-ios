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
    
    fileprivate var originalVideoViewRect = CGRect.zero
    
    private var fullScreenAnimationDuration: TimeInterval {
        return 0.15
    }
    
    static func animateToFullScreen<T: UIView>(_ videoView: T) where T: VPKVideoViewProtocol {

        videoView.fullScreenMode()
    }
    
    static func animateToNormalScreen<T: UIView>(_ videoView: T) where T: VPKVideoViewProtocol {
        print("video view frame \(videoView.frame)")
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
        
        guard let sourceFrame = originalFrame else { return }
        
        #if DEBUG
            print("source frame \(sourceFrame)")
        #endif
    
        UIView.animate(withDuration: 0.5) {
            self.snp.remakeConstraints { (make) in
                make.left.equalTo(sourceFrame.origin.x)
                make.right.equalTo(sourceFrame.width)
                make.top.equalTo(sourceFrame.origin.y)
                make.bottom.equalTo(sourceFrame.height)
            }
            self.layoutIfNeeded()
        }
    }
    
    func fullScreenMode() {
        //Expand the video
        #if DEBUG
            print("expanding into full screen")
        #endif
        
        guard   let appDelagate = UIApplication.shared.delegate,
                let safeWindow = appDelagate.window,
                let windowSize = safeWindow?.frame.size, self.playerLayer != nil else { return }
 
        self.originalFrame = self.frame //Set original frame before changing it        
        UIView.animate(withDuration: 0.5) { 
            self.snp.remakeConstraints { (make) in
                make.edges.equalTo(safeWindow!)
            }
            self.layoutIfNeeded()
        }
        
        
        
       /* safeWindow?.addSubview(fullScreenBackgroundView)
        fullScreenBackgroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(safeWindow!)
        }
        
        fullScreenBackgroundView.backgroundColor = .green
        fullScreenBackgroundView.addSubview(self)

        
        switch UIDevice.current.orientation {
        case .portrait:
            UIView.animate(withDuration: 0.5, animations: { 
                self.snp.remakeConstraints({ (make) in
                    make.edges.equalToSuperview()
                })
                //self.resize(self.playerLayer!, to: windowSize)
                self.layoutIfNeeded()
            }, completion: nil)
        case .landscapeLeft, .landscapeRight:
            UIView.animate(withDuration: 0.5, animations: {
                self.snp.remakeConstraints({ (make) in
                    make.edges.equalToSuperview()
                })
                //self.resize(self.playerLayer!, to: windowSize)
                self.layoutIfNeeded()
            }, completion: nil)
            
        default:
            break
        }*/
    }
}

extension CGAffineTransform {
    
    static let ninetyDegreeRotation = CGAffineTransform(rotationAngle: CGFloat(M_PI / 2))
    
    static func affineTransformFromRect(sourceRect: CGRect, toRect finalRect:CGRect) -> CGAffineTransform {
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: -(sourceRect.midX - finalRect.midX), y: -(sourceRect.midY - finalRect.midY))
        transform = transform.scaledBy(x: finalRect.size.width / sourceRect.size.width, y: finalRect.size.height / sourceRect.size.height)
        return transform
    }
}
