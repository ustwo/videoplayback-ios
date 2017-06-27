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
    var playbackTheme: ToolBarTheme?
    var videoType: VPKVideoType
    var shouldAutoplay: Bool?
    var indexPath: NSIndexPath?

    required public init(videoType: VPKVideoType, withAutoplay shouldAutoplay: Bool, showInCell indexPath: NSIndexPath?, playbackTheme theme: ToolBarTheme = .normal) {
        self.videoType = videoType
        self.shouldAutoplay = shouldAutoplay
        self.indexPath = indexPath
        self.videoSizeState = .normal
        self.playbackTheme = theme
    }

    private func observeVideoViewLifecycle() {
        videoView?.viewWillAppearClosure = { () in
            if self.shouldAutoplay == true {
                self.didTapVideoView()
            }
        }
    }

}

//MARK: VIEW --> Presenter
extension VPKVideoPlaybackPresenter: VPKVideoPlaybackPresenterProtocol {

    //VIEW -> PRESENTER    
    func viewDidLoad() {
        
        switch videoType {
        case let .local(videoPathName: _, fileType: _, placeholderImageName: imageName):
            videoView?.localPlaceHolderName = imageName
        case let .remote(url: _, placeholderURLName: imageURLString):
            guard let imageURL = URL(string: imageURLString) else { return }
            videoView?.remotePlaceHolderURL = imageURL
        }
    
        if self.shouldAutoplay == true {
            didTapVideoView()
        }
    }
    
    func reuseInCell() {
        interactor?.didReuseInCell()
    }
    
    func didMoveOffScreen() {
        interactor?.didMoveOffScreen()
    }
    
    func didTapVideoView() {
        
        var videoUrl: URL?
        switch videoType {
        case let .local(videoPathName: aName, fileType: aType, placeholderImageName: _) where Bundle.main.path(forResource: aName, ofType: aType) != nil:
            videoUrl = URL(fileURLWithPath: Bundle.main.path(forResource: aName, ofType: aType)!)
        case let .remote(url: remoteUrlName, placeholderURLName: _) where URL(string: remoteUrlName) != nil:
            videoUrl = URL(string: remoteUrlName)
        default:
            break
        }
        
        guard let safeVideoUrl = videoUrl else { return }
        interactor?.didTapVideo(videoURL: safeVideoUrl, at: self.indexPath)
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
    
    func didScrubTo(_ value: TimeInterval) {
        interactor?.didScrubTo(value)
    }
    
    func formattedProgressTime(from seconds: TimeInterval) -> String {
        return seconds.formattedTimeFromSeconds
    }
}

//MARK: INTERACTOR --> Presenter
extension VPKVideoPlaybackPresenter: VPKVideoPlaybackInteractorOutputProtocol {
    
    func onVideoResetPresentation() {
        videoView?.reloadInterfaceWithoutPlayerlayer()
    }
    
    func onVideoDidStartPlayingWith(_ duration: TimeInterval) {
        playbackBarView?.maximumSeconds = Float(duration)
        playbackBarView?.showDurationWith(duration.formattedTimeFromSeconds)
        playbackBarView?.toggleActionButton(PlayerState.playing.buttonImageName)
    }
    
    func onVideoPlayingFor(_ seconds: TimeInterval) {
        playbackBarView?.progressValue = roundf(Float(seconds))
    }
    
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

//MAK: Presenter transformers
fileprivate extension TimeInterval {
    var formattedTimeFromSeconds: String {
        let minutes = Int(self.truncatingRemainder(dividingBy: 3600))/60
        let seconds = Int(self.truncatingRemainder(dividingBy: 60))
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
