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
    
    weak var presenter: VPKVideoPlaybackPresenterProtocol?
    weak var playbackBarView: VPKPlaybackControlViewProtocol? {
        didSet {
            addPlaybackControlView()
        }
    }
    
    var viewWillAppearClosure: CompletionClosure?
    var playerLayer: AVPlayerLayer?
    var placeHolderName: String = "TODO_Default_image" {
        didSet {
            guard let image = UIImage(named: placeHolderName) else { return }
            placeHolder.image = image
            layoutIfNeeded()
        }
    }

    //private
    private let activityIndicator = UIActivityIndicatorView(frame: .zero)
    fileprivate let placeHolder = UIImageView(frame: .zero)
    private let tap = UITapGestureRecognizer()
    
    
    //MARK: Lifecycle
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
            presenter?.viewDidLoad()
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
    
    func addPlaybackControlView() {
        guard let safePlaybackBarView = playbackBarView as? UIView else { return } // cannot complete playback view with no playback controls
        addSubview(safePlaybackBarView)
        safePlaybackBarView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(60)
            
        }
    }
}

//MARK: Outputs
//**
//*
//*
extension VPKVideoView: VPKVideoViewProtocol {
    
    func didMoveOffScreen() {
        presenter?.didMoveOffScreen()
    }
    
    func didTapView() {
        presenter?.didTapVideoView()
    }
    
    
    func reuseInCell(_ shouldReuse: Bool) {
        
    }
    
    func showPlaceholder() {
        placeHolder.isHidden = false
    }
    
    func reloadInterface(with playerLayer: AVPlayerLayer) {
        self.playerLayer = playerLayer
        playerLayer.frame = placeHolder.bounds
        playerLayer.needsDisplayOnBoundsChange = true
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        playerLayer.zPosition = 2.0
        DispatchQueue.main.async {
            self.layer.insertSublayer(playerLayer, at: 0)
            self.placeHolder.isHidden = true
        }
    }
    
    func makeFullScreen() {
        VideoViewAnimator.animateToFullScreen(self)
    }
    
    func makeNormalScreen() {
        
    }
}
