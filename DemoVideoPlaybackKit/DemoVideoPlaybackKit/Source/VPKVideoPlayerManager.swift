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
        
//        addApplicationObservers()
  //      addPlayerObservers()
    }
    
    public func didSelectVideoUrl(_ url: URL) {
        
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
            // self.currentUrl = url
            
            let playerLayer = AVPlayerLayer(player: self.player)
            serviceGroup.notify(queue: DispatchQueue.main, execute: {
                
                self.playerLayerClosure?(playerLayer)
                self.play()
                //self.currentlyPlayingView = videoView
                self.configurePlayer(item: playerItem)
                //self.addPlayerItemObservers()
                
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
    
    private func configurePlayer(item: AVPlayerItem?) {
        player.replaceCurrentItem(with: item)
    }
    
    private func play() {
        player.play()
        player.rate = 1.0 // sets desired playback rate (full speed)
    }
    
    //MARK: Helpers
    private func isPlayerPlaying() -> Bool {
        return player.rate == 1 && player.error == nil
    }
    
}
