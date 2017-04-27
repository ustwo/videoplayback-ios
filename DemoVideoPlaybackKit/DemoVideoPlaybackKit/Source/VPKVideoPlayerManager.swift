//
//  VPKVideoPlayerManager.swift
//  VideoPlaybackKit
//
//  Created by Sonam on 4/21/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation
import RxSwift

class VPKVideoPlayerManager: NSObject {
    
    //pubic 
    public var playerLayerClosure: LayerClosure?
    public var videoURL: Variable<URL>?
    
    //private
    private var playerState: PlayerState = .paused
    private var currentVideoURL: URL?
    private static let queueIdentifier = "com.vpk.playerQueue"
    private lazy var player = AVPlayer()
    private enum ObservableKeyPaths: String {
        case status, rate, timeControlStatus
        static let allValues = [status, rate, timeControlStatus]
    }

    //MARK: Setup
    override init() {
        super.init()
        player.actionAtItemEnd = .none
       // addApplicationObservers()
        addPlayerObservers()
    }
    
    
    public func didSelectVideoUrl(_ url: URL) {
        switch playerState {
            case .playing:
                stop()
            case .paused:
                url == currentVideoURL ? play() : playVideoForTheFirstTime(url)
        }
    }
    
    private func playVideoForTheFirstTime(_ url: URL) {
        let serviceGroup = DispatchGroup()
        let backgroundQueue = DispatchQueue(label: VPKVideoPlayerManager.queueIdentifier, qos: .background, target: nil)
        
        //stop()
        let workItemOne = DispatchWorkItem {
            serviceGroup.enter()
            serviceGroup.notify(queue: DispatchQueue.main, execute: {
                //  self.currentlyPlayingView?.resetView()
            })
            serviceGroup.leave()
        }
        
        backgroundQueue.async(execute: workItemOne)
        serviceGroup.notify(queue: backgroundQueue, work: workItemOne)
        
        //Player Asset + Layer setup
        let workItemTwo = DispatchWorkItem {
            let playerAsset = AVAsset(url: url)
            let playerItem = AVPlayerItem(asset: playerAsset)
            self.currentVideoURL = url
            
            let playerLayer = AVPlayerLayer(player: self.player)
            serviceGroup.notify(queue: DispatchQueue.main, execute: {
                
                self.playerLayerClosure?(playerLayer)
                self.play()
                self.configurePlayer(item: playerItem)
                self.addPlayerItemObservers()
            })
        }
        
        serviceGroup.notify(queue: backgroundQueue, work: workItemTwo)
        backgroundQueue.async(group: serviceGroup, execute: workItemTwo)
    }
    
    public func didMoveOffScreen() {
        if isPlayerPlaying() {
            player.pause()
        }
    }
    
    //MARK: Configuration
    private func configurePlayer(item: AVPlayerItem?) {
        player.replaceCurrentItem(with: item)
    }
    
    //MARK: Playback 
    private func stop() {
        player.pause()
    }
    
    private func play() {
        player.play()
        player.rate = 1.0 // sets desired playback rate (full speed)
    }
    
    @objc private func didPlayToEnd() {
        
    }
    
    @objc private func didStopPlaying() {
        playerState = .paused
    }

    @objc private func didStartPlaying() {
        playerState = .playing
    }
    
    //MARK: KVO setup
    private func addPlayerObservers() {
        player.addObserver(self, forKeyPath: ObservableKeyPaths.status.rawValue, options: .new, context: nil)
        player.addObserver(self, forKeyPath: ObservableKeyPaths.rate.rawValue, options: .new, context: nil)
        player.addObserver(self, forKeyPath: ObservableKeyPaths.timeControlStatus.rawValue, options: .new, context: nil)
    }
    
    private func addPlayerItemObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: nil) { (notification) in
            self.didPlayToEnd()
        }
    }
    
    private func removePlayerObservers() {
        player.removeObserver(self, forKeyPath: ObservableKeyPaths.status.rawValue)
        player.removeObserver(self, forKeyPath: ObservableKeyPaths.rate.rawValue)
        player.removeObserver(self, forKeyPath: ObservableKeyPaths.timeControlStatus.rawValue)
    }
    
    private func removePlayerItemObservers() {
        if player.currentItem != nil {
            let itemQueue = DispatchQueue(label: "com.ellen.playerItemQueue", qos: .background, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
            itemQueue.async {
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
                self.configurePlayer(item: nil)
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard   let key = keyPath,
            let keyPathEnumType: ObservableKeyPaths = ObservableKeyPaths(rawValue: key) else { return }
        
        switch keyPathEnumType {
        case .timeControlStatus:
            handleObservedTimeControlStatus()
        case .rate where player.rate == 0:
            didStopPlaying()
        case .rate where player.rate == 1:
            if #available(iOS 10.0, *) { /* handled with time control status  */ break } else {
                didStartPlaying()
            }
        default:
            break
        }
    }
    
    func handleObservedTimeControlStatus() {
        if #available(iOS 10.0, *) {
            let timeStatus = player.timeControlStatus
            switch timeStatus {
            case AVPlayerTimeControlStatus.playing:
                didStartPlaying()
            default:
                break
            }
        }
    }
    
    
    //MARK: Helpers
    private func isPlayerPlaying() -> Bool {
        return player.rate == 1 && player.error == nil
    }
}
