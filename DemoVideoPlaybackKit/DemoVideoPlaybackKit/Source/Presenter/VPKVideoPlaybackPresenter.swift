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

    var videoView: VPKVideoViewProtocol? {
        didSet {
            observeVideoViewLifecycle()
        }
    }
    var playbackBarView: VPKPlaybackControlViewProtocol?
    var interactor: VPKVideoPlaybackInteractorInputProtocol?
    var builder: VPKVideoPlaybackBuilderProtocol?
    var videoSizeState: VideoSizeState?
    
    var videoType: VPKVideoType
    var placeHolderName: String? {
        didSet {
            guard let safeName = placeHolderName else { return }
            videoView?.placeHolderName = safeName
        }
    }
    
    var shouldAutoplay: Bool?
    var isInCell: Bool?

    required public init(videoType: VPKVideoType, withPlaceholder placeHolderName: String, withAutoplay shouldAutoplay: Bool, showInCell isInCell: Bool) {
        self.videoType = videoType
        self.placeHolderName = placeHolderName
        self.shouldAutoplay = shouldAutoplay
        self.isInCell = isInCell
        self.videoSizeState = .normal
    }

    private func observeVideoViewLifecycle() {
        videoView?.viewWillAppearClosure = { () in
            if self.shouldAutoplay == true {
                self.didTapVideoView()
            }
        }
    }
    
    public func didScrub() {
        
    }
}

extension VPKVideoPlaybackPresenter: VPKVideoPlaybackPresenterProtocol {
    
    //VIEW -> PRESENTER    
    func viewDidLoad() {
        videoView?.placeHolderName = placeHolderName ?? "default_placeholder"
        if self.shouldAutoplay == true {
            didTapVideoView()
        }
    }
    
    func didMoveOffScreen() {
        interactor?.didMoveOffScreen()
    }
    
    func didTapVideoView() {
        var videoUrl: URL?
        switch videoType {
        case let .local(pathName: aName, fileType: aType) where Bundle.main.path(forResource: aName, ofType: aType) != nil:
            videoUrl = URL(fileURLWithPath: Bundle.main.path(forResource: aName, ofType: aType)!)
            
        case let .remote(url: remoteUrlName) where URL(string: remoteUrlName) != nil:
            videoUrl = URL(string: remoteUrlName)
        default:
            break
        }
        
        guard let safeVideoUrl = videoUrl else { return }
        interactor?.didTapVideo(videoURL: safeVideoUrl)
    }
    
    public func didExpand() {
        guard let state = videoSizeState else { return }
        switch state {
        case .normal:
            videoView?.makeFullScreen()
        case .fullScreen:
            videoView?.makeNormalScreen()
        }
        
      videoSizeState?.toggle()
    }
}

extension VPKVideoPlaybackPresenter: VPKVideoPlaybackInteractorOutputProtocol {
    
    func onVideoDidPlayToEnd() {
        videoView?.showPlaceholder()
        playbackBarView?.toggleActionButton(PlayerState.paused.buttonImageName)
    }
    
    func onVideoDidStopPlaying() {
        playbackBarView?.toggleActionButton(PlayerState.paused.buttonImageName)
    }
    
    func onVideoDidStartPlaying() {
        playbackBarView?.toggleActionButton(PlayerState.playing.buttonImageName)
    }

    func onVideoLoadSuccess(_ playerLayer: AVPlayerLayer) {
        videoView?.reloadInterface(with: playerLayer)
    }
    
    func onVideoLoadFail(_ error: String) {
        
    }
}
