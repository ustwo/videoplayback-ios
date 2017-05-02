//
//  VPKVideoViewPresenter.swift
//  VideoPlaybackKit
//
//  Created by Sonam on 4/21/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import AVFoundation

public class VPKVideoPlaybackPresenter {

    var videoView: VPKVideoViewProtocol?
    var interactor: VPKVideoPlaybackInteractorInputProtocol?
    var builder: VPKVideoPlaybackBuilderProtocol?
    
    var videoURL: URL?
    var imageName: String?
    var filePathURL: URL?
    var autoPlay: Bool?

    
    convenience init() {
        self.init()
        self.videoURL = nil
        self.filePathURL = nil
        self.autoPlay = nil
        self.imageName = nil
    }
    
    init(videoURLString: String, placeHolder: String, shouldAutoplay: Bool = false) {
        self.videoURL = URL(string: videoURLString)
        self.filePathURL = nil
        self.autoPlay = shouldAutoplay
        self.imageName = placeHolder
        setup()
    }
    
    init(localFileName: String, fileType: String, placeHolder: String, shouldAutoplay: Bool = false ) {
        self.autoPlay = shouldAutoplay
        guard let safeFilePath = Bundle.main.path(forResource: localFileName, ofType: fileType)else {
                self.filePathURL = nil
                self.imageName = nil
                self.videoURL = nil
                return
        }
        
        self.filePathURL = URL(fileURLWithPath: safeFilePath)
        self.imageName = placeHolder
        self.videoURL = nil
        setup()
    }
    
    private func setup() {
       // onVideoPlayerLoadSuccess()
    }
    
    func localVideoView() -> VPKVideoViewProtocol {
        videoView = VPKVideoView(presenter: self)
        videoView?.placeHolderName = imageName
        return videoView!
    }
    
    private func observeVideoViewLifecycle() {
        videoView?.viewWillAppearClosure = { () in
            if self.autoPlay == true {
                self.didTapVideoView()
            }
        }
    }
    

    
    public func didScrub() {
        
    }
    
    public func didToggeViewExpansion() {
        
    }

}

extension VPKVideoPlaybackPresenter: VPKVideoPlaybackPresenterProtocol {
    
    //VIEW -> PRESENTER    
    func viewDidLoad() {
        
    }
    
    func didMoveOffScreen() {
        interactor?.didMoveOffScreen()
    }
    
    func didTapVideoView() {
        if let localFilePathURL = filePathURL {
            interactor?.didTapVideo(videoURL: localFilePathURL)
        } else if let remoteURL = videoURL {
            interactor?.didTapVideo(videoURL: remoteURL)
        }
    }
}

extension VPKVideoPlaybackPresenter: VPKVideoPlaybackInteractorOutputProtocol {
   
    func onVideoLoadSuccess(_ playerLayer: AVPlayerLayer) {
        videoView?.reloadInterface(with: playerLayer)
    }
    
    func onVideoLoadFail(_ error: String) {
        
    }
    
    func onStateChange(_ startState: PlayerState, to endState: PlayerState) {
        
    }
}
