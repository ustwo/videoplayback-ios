//
//  VPKVideoViewPresenter.swift
//  VideoPlaybackKit
//
//  Created by Sonam on 4/21/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import UIKit

public class VPKVideoViewPresenter {
    
    let videoURL: URL?
    let image: UIImage?
    let filePathURL: URL?
    fileprivate let interactor = VPKVideoPlayerInteractor()
    fileprivate var videoView: VPKVideoView?
    
    
    init(videoURLString: String, placeHolder: String) {
        self.videoURL = URL(string: videoURLString)
        self.filePathURL = nil
        guard let safeImage = UIImage(named: placeHolder) else {
            self.image = nil
            return
        }
        
        self.image = safeImage
        observeOnVideoLoadSuccess()
    }
    
    init(localFileName: String, fileType: String, placeHolder: String) {
        guard let safeFilePath = Bundle.main.path(forResource: localFileName, ofType: fileType),
            let safeImage = UIImage(named: placeHolder) else {
                self.filePathURL = nil
                self.image = nil
                self.videoURL = nil
                return
        }
        
        self.filePathURL = URL(fileURLWithPath: safeFilePath)
        self.image = safeImage
        self.videoURL = nil
        observeOnVideoLoadSuccess()
    }

    
    public func localVideoView() -> VPKVideoView {
        videoView = VPKVideoView(presenter: self)
        videoView?.placeHolderImage = image
        return videoView!
    }
    
    
    //MARK: Actions for interactor input
    public func didTapVideoView() {
        if let localFilePathURL = filePathURL {
            interactor.didTapVideo(videoURL: localFilePathURL)
        } else if let remoteURL = videoURL {
            interactor.didTapVideo(videoURL: remoteURL)
        }
    }
    
    public func didScrub() {
        
    }
    
    public func didToggeViewExpansion() {
        
    }
    
    public func didMoveOffScreen() {
        interactor.didMoveOffScreen()
    }
    
    //MARK: Interactor output
    func observeOnVideoLoadSuccess() {
        interactor.onVideoLoadSuccess = { (playerLayer) in
            self.videoView?.setPlayerLayer(playerLayer)
        }
    }
}
