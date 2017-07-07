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
import PINCache


class VPKVideoPlaybackManager: NSObject, VPKVideoPlaybackManagerProtocol {
    
    
    weak var delegate: VPKVideoPlaybackDelegate?
    static let shared = VPKVideoPlaybackManager()
    /// The default directory for scratch file caching.
    
    static let defaultDirectory: URL = {
        let caches = FileManager.default.cachesDirectory()!
        return caches.appendingPathComponent(
            "VPKPlaybackManager",
            isDirectory: true
        )
    }()

    static let assetKeysRequiredToPlay = [
        "playable",
        "hasProtectedContent"
    ]

    private var asset: AVAsset? {
        didSet {
            guard let newAsset = asset else { return }
            asynchronouslyLoadURLAsset(newAsset)
        }
    }
    
    private var playerItem: AVPlayerItem? = nil {
        didSet {
            player.replaceCurrentItem(with: self.playerItem)
        }
    }
    
    //state
    var playerState: PlayerState?
    var currentVideoUrl: URL?
    var isPlaying: Bool {
        return self.isPlayerPlaying()
    }
    
    //output
    var onStartPlayingWithDurationClosure: StartWithDurationClosure?
    var onStopPlayingClosure: CompletionClosure?
    var onDidPlayToEndClosure: CompletionClosure?
    var onPlayerLayerClosure: LayerClosure?
    var onTimeDidChangeClosure: TimeClosure?
    
    //private
    fileprivate var isSeekInProgress = false
    fileprivate var chaseTime = kCMTimeZero
    fileprivate static let queueIdentifier = "com.vpk.playerQueue"
    fileprivate lazy var player = AVQueuePlayer()
    fileprivate var playerLooper: AVPlayerLooper?
    fileprivate var resourceLoaderDelegate: VPKAssetResourceLoaderDelegate?
    
    fileprivate lazy var playerLayer = AVPlayerLayer(player: VPKVideoPlaybackManager.shared.player)
    fileprivate enum ObservableKeyPaths: String {
        case status, rate, timeControlStatus, likelyToKeepUp
        static let allValues = [status, rate, timeControlStatus]
    }
    
    //public 
    var loopEnabled: Bool = true

    //MARK: Setup
    override init() {
        super.init()
        playerState = .paused
        player.actionAtItemEnd = .none
        player.automaticallyWaitsToMinimizeStalling = true
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        
      //  addApplicationObservers()
        trackTimeProgress()
        addPlayerObservers()
    }
    
    
    fileprivate func playVideoForTheFirstTime(_ url: URL) {
        if PINCache.shared().containsObject(forKey: url.path) {
            
        
        }
        
        let resourceDelegate = VPKAssetResourceLoaderDelegate(customLoadingScheme: "VPKPlayback", resourcesDirectory: VPKVideoPlaybackManager.defaultDirectory, defaults: UserDefaults.standard)
        let asset = resourceDelegate.prepareAsset(for: url)
        player.replaceCurrentItem(with: AVPlayerItem(asset: asset!))
                
        /*
        let serviceGroup = DispatchGroup()
        let backgroundQueue = DispatchQueue(label: VPKVideoPlaybackManager.queueIdentifier, qos: .background, target: nil)
        
        let workItemOne = DispatchWorkItem {
            serviceGroup.enter()
            serviceGroup.notify(queue: backgroundQueue, execute: {
                self.asset = AVAsset(url: url)
                self.currentVideoUrl = url
            
                if self.loopEnabled && self.playerItem != nil  {
                    self.player.actionAtItemEnd = .advance
                    self.playerLooper = AVPlayerLooper(player: self.player, templateItem: self.playerItem!)
                }
            })
            serviceGroup.leave()
        }
        
        backgroundQueue.async(execute: workItemOne)
        serviceGroup.notify(queue: backgroundQueue, work: workItemOne)
        
        //Player Asset + Layer setup
        let workItemTwo = DispatchWorkItem {
            serviceGroup.notify(queue: DispatchQueue.main, execute: {
                self.didPreparePlayerLayer(self.playerLayer)
                self.play()
                self.addPlayerItemObservers()
            })
        }
        
        serviceGroup.notify(queue: backgroundQueue, work: workItemTwo)
        backgroundQueue.async(group: serviceGroup, execute: workItemTwo)
         */
 
    }
    
    // MARK: - Asset Loading
    func preloadAssetWith(url: URL) {
        let urlAsset = AVURLAsset(url: url)
        urlAsset.loadValuesAsynchronously(forKeys: VPKVideoPlaybackManager.assetKeysRequiredToPlay) {

            
        }
    }
    
    func asynchronouslyLoadURLAsset(_ newAsset: AVAsset) {
        //*** Based on Apple's demo AVFoundation sample code **** 
        
        /*
         Using AVAsset now runs the risk of blocking the current thread (the
         main UI thread) whilst I/O happens to populate the properties. It's
         prudent to defer our work until the properties we need have been loaded.
         */
        newAsset.loadValuesAsynchronously(forKeys: VPKVideoPlaybackManager.assetKeysRequiredToPlay) {
            /*
             The asset invokes its completion handler on an arbitrary queue.
             To avoid multiple threads using our internal state at the same time
             we'll elect to use the main thread at all times, let's dispatch
             our handler to the main queue.
             */
            DispatchQueue.main.async {
                /*
                 `self.asset` has already changed! No point continuing because
                 another `newAsset` will come along in a moment.
                 */
                guard newAsset == self.asset else { return }
                
                /*
                 Test whether the values of each of the keys we need have been
                 successfully loaded.
                 */
                for key in VPKVideoPlaybackManager.assetKeysRequiredToPlay {
                    var error: NSError?
                    if newAsset.statusOfValue(forKey: key, error: &error) == .failed {
                        let stringFormat = NSLocalizedString("error.asset_key_%@_failed.description", comment: "Can't use this AVAsset because one of it's keys failed to load")
                        let message = String.localizedStringWithFormat(stringFormat, key)
                        self.handleErrorWithMessage(message, error: error)
                        return
                    }
                }
                
                // We can't play this asset.
                if !newAsset.isPlayable || newAsset.hasProtectedContent {
                    let message = NSLocalizedString("error.asset_not_playable.description", comment: "Can't use this AVAsset because it isn't playable or has protected content")
                    self.handleErrorWithMessage(message)
                    return
                }
                
                /*
                 We can play this asset. Create a new `AVPlayerItem` and make
                 it our player's current item.
                 */
                self.playerItem = AVPlayerItem(asset: newAsset)
            }
        }
    }
    
    // MARK: - Error Handling
    func handleErrorWithMessage(_ message: String?, error: Error? = nil) {
        NSLog("Error occured with message: \(String(describing: message)), error: \(String(describing: error)).")
        guard let safeError = error else { return }
        delegate?.playbackManager(VPKVideoPlaybackManager.shared, didFailWith: safeError)
    }
    
    
    //MARK: Configuration
    fileprivate func configurePlayer(item: AVPlayerItem?) {
        let queue = DispatchQueue(label: "item_exchange")
        queue.async {
            self.player.replaceCurrentItem(with: item)
        }
    }
    
    //MARK: Playback 
    public func stop() {
        player.pause()
    }
    
    fileprivate func play() {
        player.playImmediately(atRate: 1.0)
    }
    
    //MARK: KVO setup
    fileprivate func trackTimeProgress() {
        let timeQueue = DispatchQueue(label: "time_tracking")
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 1000), queue: timeQueue) { [weak self] (time) in
            self?.videoPlayingTimeChangedTo(time.seconds)
        }
    }
    
    private func addPlayerObservers() {
        ObservableKeyPaths.allValues.forEach { (keyPath) in
            player.addObserver(self, forKeyPath: keyPath.rawValue, options: .new, context: nil)
        }
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
    
    fileprivate func removePlayerItemObservers() {
        if player.currentItem != nil {
            let itemQueue = DispatchQueue(label: "com.vpk.playerItemQueue", qos: .background, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
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
        case .likelyToKeepUp:
            print("PLAYBACK likely to keep up")
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
                print(player.timeControlStatus.rawValue)
                print(player.reasonForWaitingToPlay?.description ?? "reason unknown")
                break
            }
        }
    }

    //MARK: Helpers
    func isPlayerPlaying() -> Bool {
        return player.rate == 1 && player.error == nil
    }
    
    deinit {
        removePlayerObservers()
    }
}

extension VPKVideoPlaybackManager: VPKVideoPlaybackManagerOutputProtocol {
    
    fileprivate func didPreparePlayerLayer(_ playerLayer: AVPlayerLayer) {
        delegate?.playbackManager(self, didPrepare: playerLayer)
    }
    
    fileprivate func didStopPlaying() {
        #if DEBUG
            print("stopped playing")
        #endif
            
        playerState = .paused
        delegate?.playbackManagerDidStopPlaying(self)
    }
    
    fileprivate func didStartPlaying() {
        #if DEBUG
            print("started playing")
        #endif
        
        guard let duration = player.currentItem?.asset.duration,
            let transformedTime = CMTimeGetSeconds(duration) as? Double else {
                #if DEBUG
                    print("error getting player asset duration")
                #endif
            return
        }
        
        playerState = .playing
        delegate?.playbackManager(self, didStartPlayingWith: transformedTime)
    }
    
    fileprivate func didPlayToEnd() {
        playerState = .paused
        configurePlayer(item: nil)
        delegate?.playbackManagerDidPlayToEnd(self)
    }
    
    fileprivate func videoPlayingTimeChangedTo(_ time: TimeInterval) {
        delegate?.playbackManager(self, didChange: time)
    }
}

extension VPKVideoPlaybackManager: VPKVideoPlaybackManagerInputProtocol {
    
    func didScrubTo(_ seconds: TimeInterval) {
        #if DEBUG
            print("USER SCRUBBED VIDEO TO \(seconds)")
        #endif
        stopPlayingAndSeekSmoothlyToTime(newChaseTime: CMTimeMakeWithSeconds(seconds, 1))
    }
    
    func didReuseInVideoCell() {
        if isPlayerPlaying() {
          cleanup()
        }
    }
    
    func didMoveOffScreen()  {
        if isPlayerPlaying() {
            cleanup()
        }
    }
    
    func didSelectVideoUrl(_ url: URL) {
        //TODO: REFACTOR
        guard let state = playerState else { return }
        switch state {
        case .paused where currentVideoUrl == nil:
            playVideoForTheFirstTime(url)
        case .playing where url == currentVideoUrl:
            stop()
        case .playing where url != currentVideoUrl, .paused where url != currentVideoUrl:
            cleanup()
            playVideoForTheFirstTime(url)
        case .paused where url == currentVideoUrl:
            play()
        default:
            break
        }
    }
    
    func cleanup() {
        stop()
        currentVideoUrl = nil
        configurePlayer(item: nil)
        removePlayerItemObservers()
        delegate?.playbackManagerDidPlayNewVideo(self)
    }
}

//MARK: Time Scrubbing
extension VPKVideoPlaybackManager {
    
    func stopPlayingAndSeekSmoothlyToTime(newChaseTime: CMTime) {
        player.pause()
        if CMTimeCompare(newChaseTime, chaseTime) != 0 {
            chaseTime = newChaseTime
            if !isSeekInProgress {
                trySeekToChaseTime()
            }
        }
    }
    
    fileprivate func trySeekToChaseTime() {        
        if player.currentItem?.status == .unknown {
            // wait until item becomes ready (KVO player.currentItem.status)
        } else if player.currentItem?.status  == .readyToPlay {
            actuallySeekToTime()
        }
    }
    
    fileprivate func actuallySeekToTime() {
        isSeekInProgress = true
        let seekTimeInProgress = chaseTime
        player.seek(to: seekTimeInProgress, toleranceBefore: kCMTimeZero,
                    toleranceAfter: kCMTimeZero, completionHandler:
            { (isFinished) -> () in
                if CMTimeCompare(seekTimeInProgress, self.chaseTime) == 0 {
                    self.isSeekInProgress = false
                    self.play()
                }
                else {
                    self.trySeekToChaseTime()
                }
        })
    }
}
