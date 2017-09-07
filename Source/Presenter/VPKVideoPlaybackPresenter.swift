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
    
    static let fadeOutTime: TimeInterval = 3.0
    
    var videoView: VPKVideoViewProtocol? {
        didSet {
            observeVideoViewLifecycle()
        }
    }
    
    var hasFadedOutControlView: Bool = false
    
    var progressTime = 0.0
    var playbackBarView: VPKPlaybackControlViewProtocol?
    var interactor: VPKVideoPlaybackInteractorInputProtocol?
    var builder: VPKVideoPlaybackBuilderProtocol?
    var videoSizeState: VideoSizeState?
    var playbackTheme: ToolBarTheme?
    var shouldAutoplay: Bool?
    var indexPath: NSIndexPath?
    var duration: TimeInterval?
    
    
    required public init(with autoPlay:Bool = false, showInCell indexPath: NSIndexPath?, playbackTheme theme: ToolBarTheme) {
        
        self.shouldAutoplay = autoPlay
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
        
        
        //Update the default image
        if let localImage = interactor?.localImageName {
            videoView?.localPlaceHolderName = localImage
        } else if let remoteImageURL = interactor?.remoteImageURL {
            videoView?.remotePlaceHolderURL = remoteImageURL
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
        guard let safeVideoUrl = interactor?.videoType.videoUrl else { return }
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
    
    
    func didSkipBack(_ seconds: Float) {
        didScrubTo(TimeInterval(seconds))
    }
    
    func didSkipForward(_ seconds: Float) {
        didScrubTo(TimeInterval(seconds))
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
        self.duration = duration
        playbackBarView?.maximumSeconds = Float(duration)
        playbackBarView?.showDurationWith(duration.formattedTimeFromSeconds)
        playbackBarView?.toggleActionButton(PlayerState.playing.buttonImageName)
    }
    
    func onVideoPlayingFor(_ seconds: TimeInterval) {
        
        playbackBarView?.progressValue = Float(seconds)
        playbackBarView?.updateTimePlayingCompletedTo(seconds.formattedTimeFromSeconds)
        self.progressTime = seconds
        
        if videoIsReachingTheEnd() {
            fadeInControlBarView()
            hasFadedOutControlView = false
        } else if videoHasBeenPlaying(for: VPKVideoPlaybackPresenter.fadeOutTime) && hasFadedOutControlView == false {
            hasFadedOutControlView = true
            fadeOutControlBarView()
        }
    }
    
    func videoHasBeenPlaying(for seconds: TimeInterval) -> Bool  {
        
        return (seconds...seconds + 5).contains(progressTime)
    }
    
    func videoIsReachingTheEnd() -> Bool {
        
        guard let safeDuration = duration else { return false }
        let timeLeft = safeDuration - progressTime
        return timeLeft <= 5.0
    }
    
    func fadeOutControlBarView() {
        guard let playbackView = playbackBarView else { return }
        PlaybackControlViewAnimator.fadeOut(playbackView)
    }
    
    func fadeInControlBarView() {
        guard let playbackView = playbackBarView else { return }
        PlaybackControlViewAnimator.fadeIn(playbackView)
    }
    
    func onVideoDidPlayToEnd() {
        videoView?.showPlaceholder()
        playbackBarView?.toggleActionButton(PlayerState.paused.buttonImageName)
        playbackBarView?.progressValue = 0.0
    }
    
    func onVideoDidStopPlaying() {
        playbackBarView?.toggleActionButton(PlayerState.paused.buttonImageName)
        
        guard let controlView = playbackBarView else {
            assertionFailure("control view is nil")
            return
        }
        
        PlaybackControlViewAnimator.fadeIn(controlView)
    }
    
    func onVideoDidStartPlaying() {
        videoView?.activityIndicator.stopAnimating()
        playbackBarView?.toggleActionButton(PlayerState.playing.buttonImageName)
    }
    
    func onVideoLoadSuccess(_ playerLayer: AVPlayerLayer) {
        videoView?.reloadInterface(with: playerLayer)
    }
    
    func onVideoLoadFail(_ error: String) {
        //TODO: (SD) PASS ERROR
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
