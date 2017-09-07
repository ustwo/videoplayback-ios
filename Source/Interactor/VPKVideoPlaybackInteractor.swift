//
//  VPKVideoPlayerInteractor.swift
//  VideoPlaybackKit
//
//  Created by Sonam on 4/24/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation


public class VPKVideoPlaybackInteractor: VPKVideoPlaybackInteractorProtocol {
    
    
    var playbackManager: (VPKVideoPlaybackManagerInputProtocol & VPKVideoPlaybackManagerOutputProtocol & VPKVideoPlaybackManagerProtocol)?
    var videoType: VPKVideoType
    var remoteImageURL: URL?
    var localImageName: String?
    
    weak var presenter: VPKVideoPlaybackInteractorOutputProtocol?
    
    
    required public init(entity: VPKVideoType) {
        
        self.videoType = entity
        prepareEntityDataForPresenter()
    }
    
    private func prepareEntityDataForPresenter() {
        
        switch videoType {
        case let .local(videoPathName: _, fileType: _, placeholderImageName: imageName):
            localImageName = imageName
            
        case let .remote(url: _, placeholderURLName: imageURLString):
            guard URL(string: imageURLString) != nil else { return }
            remoteImageURL = URL(string: imageURLString)!
        }
    }
}

// MARK: - Interactor Input. Passes inputs to the external playback data manager . You can also think of the data manager as an event handler

extension VPKVideoPlaybackInteractor: VPKVideoPlaybackInteractorInputProtocol {

    func didTapVideo(videoURL: URL, at indexPath: NSIndexPath? = nil) {
        
        playbackManager?.didSelectVideoUrl(videoURL)
        playbackManager?.delegate = self
    }
    
    func didReuseInCell() {
        
        playbackManager?.didReuseInVideoCell()
    }
    
    func didScrubTo(_ timeInSeconds: TimeInterval) {
        playbackManager?.didScrubTo(timeInSeconds)
    }
    
    func didSkipBack(_ seconds: Float) {
        
    }
    
    func didSkipForward(_ seconds: Float) {
        
    }
    
    func didToggleViewExpansion() {
        
    }
    
    func didMoveOffScreen() {
        playbackManager?.didMoveOffScreen()
    }
}

extension VPKVideoPlaybackInteractor: VPKVideoPlaybackDelegate {
    
    func playbackManagerDidPlayNewVideo(_: VPKVideoPlaybackManager) {
        presenter?.onVideoResetPresentation()
    }
    
    @available(iOS 10, *)
    func playbackManager(_: VPKVideoPlaybackManager, didPrepare playerLayer: AVPlayerLayer) {
        presenter?.onVideoLoadSuccess(playerLayer)
    }
    
    @available(iOS 10, *)
    func playbackManager(_: VPKVideoPlaybackManager, didStartPlayingWith duration: TimeInterval) {
        presenter?.onVideoDidStartPlayingWith(duration)
    }
    
    
    func playbackManager(_: VPKVideoPlaybackManager, didChange time: TimeInterval) {
        presenter?.onVideoPlayingFor(time)
    }
    
    func playbackManager(_: VPKVideoPlaybackManager, didFailWith error: Error) {
        //TODO:
    }
    
    func playbackManagerDidStopPlaying(_: VPKVideoPlaybackManager) {
        presenter?.onVideoDidStopPlaying()
    }
    
    func playbackManagerDidPlayToEnd(_: VPKVideoPlaybackManager) {
        presenter?.onVideoDidPlayToEnd()
    }
}
