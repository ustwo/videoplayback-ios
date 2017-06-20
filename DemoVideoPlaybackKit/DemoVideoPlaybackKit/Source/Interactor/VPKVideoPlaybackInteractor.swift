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
import RxSwift

struct FeedPlaybackHistory {
    
    static var shared = FeedPlaybackHistory()
    public typealias PlaybackMapDictionary = [NSIndexPath: VPKVideoPlaybackInteractor]
    
    var history =  [PlaybackMapDictionary]()
}

struct FeedPlaybackCache {
    
    static let shared = FeedPlaybackCache()
    static let currentRowKey = "currently_playing_row"
    static let currentSectionKey = "currently_playing_section"
    
    func persistVideoPlayingAt(_ indexPath: NSIndexPath?) {
        guard let safeIndexPath = indexPath else { return }
        let row = safeIndexPath.row
        let section = safeIndexPath.section
        UserDefaults.standard.set(row, forKey: FeedPlaybackCache.currentRowKey)
        UserDefaults.standard.set(section, forKey: FeedPlaybackCache.currentSectionKey)
        UserDefaults.standard.synchronize()
    }
    
    func currentlyPlayingIndexPath() -> NSIndexPath? {
        if UserDefaults.standard.dictionaryRepresentation().keys.index(of: FeedPlaybackCache.currentRowKey) != nil {
        
            guard let row = UserDefaults.standard.object(forKey: FeedPlaybackCache.currentRowKey) as? Int,
                let section = UserDefaults.standard.object(forKey: FeedPlaybackCache.currentSectionKey) as? Int else { return nil }
            return NSIndexPath(row: row, section: section)
        }
        
        return nil
    }
    
}

public class VPKVideoPlaybackInteractor: VPKVideoPlaybackInteractorInputProtocol {
    
    var playbackManager: (VPKVideoPlaybackManagerInputProtocol & VPKVideoPlaybackManagerOutputProtocol & VPKVideoPlaybackManagerProtocol)?
    weak var presenter: VPKVideoPlaybackInteractorOutputProtocol?
    

    func didTapVideo(videoURL: URL, at indexPath: NSIndexPath? = nil) {
        playbackManager?.didSelectVideoUrl(videoURL)
        
        playbackManager?.delegate = self

        
       /* playbackManager?.onPlayerLayerClosure = { [weak self] (playerLayer) in
            
            //FeedPlaybackCache.shared.persistVideoPlayingAt(indexPath)
            self?.presenter?.onVideoLoadSuccess(playerLayer)
        }
        
        playbackManager?.onStartPlayingWithDurationClosure = { [weak self] (duration) in
            self?.presenter?.onVideoDidStartPlayingWith(duration)
        }
        
        playbackManager?.onStopPlayingClosure = { [weak self] () in
            self?.presenter?.onVideoDidStopPlaying()
        }
        
        playbackManager?.onDidPlayToEndClosure = { [weak self] () in
            self?.presenter?.onVideoDidPlayToEnd()
        }
        
        playbackManager?.onTimeDidChangeClosure = { [weak self] (time) in
            self?.presenter?.onVideoPlayingFor(time)
        }*/
    }
    
    func didScrubTo(_ timeInSeconds: TimeInterval) {
        playbackManager?.didScrubTo(timeInSeconds)                
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
    
    func playbackManager(_: VPKVideoPlaybackManager, didPreparePlayerLayer playerLayer: AVPlayerLayer) {
        presenter?.onVideoLoadSuccess(playerLayer)
    }
    
    
    func playbackManager(_: VPKVideoPlaybackManager, didStartPlayingWithDuration duration: TimeInterval) {
        presenter?.onVideoDidStartPlayingWith(duration)
    }
    
    func playbackManager(_: VPKVideoPlaybackManager, didChangePlayingTime time: TimeInterval) {
        presenter?.onVideoPlayingFor(time)
    }
    
    func playbackManager(_: VPKVideoPlaybackManager, didFailWithError error: Error) {
        //TODO::::
    }
    
    func playbackManagerDidStopPlaying(_: VPKVideoPlaybackManager) {
        presenter?.onVideoDidStopPlaying()
    }
    
    func playbackManagerDidPlayToEnd(_: VPKVideoPlaybackManager) {
        presenter?.onVideoDidPlayToEnd()
    }
}
