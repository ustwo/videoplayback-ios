//
//  VPKVideoView.swift
//  VideoPlaybackKit
//
//  Created by Sonam on 4/21/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation
import SnapKit

private enum LayerHierachy: CGFloat {
    case bottom = 0, middle, top
}

public class VPKVideoView: UIView, UIGestureRecognizerDelegate  {
    
    var presenter: VPKVideoPlaybackPresenterProtocol?
    var viewWillAppearClosure: CompletionClosure?
    var placeHolderName: String? {
        didSet {
            guard let name = placeHolderName, let image = UIImage(named: name) else { return }
            placeHolder.image = image 
        }
    }

    //private
    private let activityIndicator = UIActivityIndicatorView(frame: .zero)
    private let actionButton = UIButton()
    private let placeHolder = UIImageView(frame: .zero)
    fileprivate var playerLayer: AVPlayerLayer?
    private let tap = UITapGestureRecognizer()
    
    
    //MARK: Lifecycle
    convenience init(presenter: VPKVideoPlaybackPresenterProtocol) {
        self.init(frame: .zero)
        self.presenter = presenter
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil {
            viewWillAppearClosure?()
        }
    }
    
    //MARK: UI
    private func setup() {
        isUserInteractionEnabled = true
        
        tap.delegate = self
       // tap.addTarget(self, action: #selector(didTapView))
        addGestureRecognizer(tap)
        tap.numberOfTapsRequired = 1
        
        addSubview(placeHolder)
        placeHolder.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        placeHolder.contentMode = .scaleAspectFit
        
        
        addSubview(actionButton)
        actionButton.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.width.height.equalTo(80)
        }
        actionButton.addTarget(self, action: #selector(didTapView), for: .touchUpInside)
        actionButton.setTitle("Trigger", for: .normal)
        actionButton.layer.zPosition = LayerHierachy.middle.rawValue
        
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
        }
        activityIndicator.color = .white
        activityIndicator.layer.zPosition = LayerHierachy.top.rawValue
    }
    
    override public func removeFromSuperview() {
        super.removeFromSuperview()
        didMoveOffScreen()
    }
}

extension VPKVideoView: VPKVideoViewProtocol {
    
    func didMoveOffScreen() {
        presenter?.didMoveOffScreen()
    }
    
    func didTapView() {
        presenter?.didTapVideoView()
    }
    
    func reuseInCell(_ shouldReuse: Bool) {
        
    }
    
    func reloadInterface(with playerLayer: AVPlayerLayer) {
        self.playerLayer = playerLayer
        playerLayer.frame = self.bounds
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        playerLayer.zPosition = LayerHierachy.top.rawValue
        layer.insertSublayer(playerLayer, at: 0)
    }
}

    /*
 
    func resetView() {
        placeHolder.image = nil
        placeHolder.layer.zPosition = LayerHierachy.top.rawValue
       // placeHolder.fadeIn(time: 0.3, completion: nil) //TODO: Add cross fade animation between placeholder and playerlayer in VideoAnimator
        activityIndicator.stopAnimating()
      //  VideoViewAnimator.animateVideoPlayerView(self, fromState: .playing, toState: .paused, withCompletion: nil)
    }
    
    
    private func playNewVideo(url: URL) {
        /*VideoViewAnimator.animateVideoPlayerView(self, fromState: .paused, toState: .playing, withCompletion: {
            self.videoManager?.playVideoUrl(url, withPlaceHolder: self.placeHolder, inView: self, returnedLayer: { [weak self] (playerLayer) in
                guard let currentBounds = self?.bounds else { return }
                playerLayer.frame =  currentBounds
                playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                playerLayer.isHidden = false
                self?.layer.insertSublayer(playerLayer, below: self?.playButton.layer)
                self?.placeHolder.layer.zPosition = LayerHierachy.middle.rawValue
                playerLayer.zPosition = LayerHierachy.bottom.rawValue
                self?.playerLayer = playerLayer
            })
        })*/
    }
    
    private func resumePlayingSameVideo() {
        videoManager?.play()
        playButton.fadeOut(time: 0.3, completion: nil)
    }
    
    private func stopPlayback() {
        videoManager?.stop()
        activityIndicator.stopAnimating()
    }
}

//MARK: Video Manager Callbacks
extension VideoPlayerView: VideoPlayerDelegate {
    
    func didStopPlaying() {
        VideoViewAnimator.animateVideoPlayerView(self, fromState: .playing, toState: .paused, withCompletion: nil)
    }
    
    func didStartPlaying() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.placeHolder.fadeOut(time: 0.3, completion: nil)
            self.playButton.fadeOut(time: 0.3, completion: nil)
        }
    }
    
    func didFail(error: Error) {
        //TODO: Handle error state
        print(error)
    }
    
    func didPlayToEnd() {
        resetView()
    }
 */
