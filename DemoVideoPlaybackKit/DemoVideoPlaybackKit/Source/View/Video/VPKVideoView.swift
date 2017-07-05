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
import AlamofireImage

private enum LayerHierachy: CGFloat {
    case bottom = 0, middle, top
}

public class VPKVideoView: UIView, UIGestureRecognizerDelegate  {
    
    weak var presenter: VPKVideoPlaybackPresenterProtocol?
    var originalFrame: CGRect?
    var fullScreenBGView = UIView(frame: .zero)
    var originalSuperview = UIView(frame: .zero)
    
    weak var playbackBarView: VPKPlaybackControlViewProtocol? {
        didSet {
            addPlaybackControlView()
            layoutIfNeeded()
        }
    }
    
    var viewWillAppearClosure: CompletionClosure?
    weak var playerLayer: AVPlayerLayer?
    
    var localPlaceHolderName: String = "TODO_Default_image" {
        didSet {
            guard let image = UIImage(named: localPlaceHolderName) else { return }
            placeHolder.image = image
            layoutIfNeeded()
        }
    }
    
    var remotePlaceHolderURL: URL? {
        didSet {
            guard let safeURL = remotePlaceHolderURL else { return }
            placeHolder.af_setImage(withURL: safeURL, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue(label: "image_queue"), imageTransition: UIImageView.ImageTransition.crossDissolve(0.3), runImageTransitionIfCached: false, completion: nil)
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
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer?.frame = self.bounds //Ensures the player layer will change as the view changes 
    }
    
    override public class var layerClass: AnyClass {
        return AVPlayerLayer.self
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
        
        self.backgroundColor = .clear
        
        tap.delegate = self
        tap.addTarget(self, action: #selector(didTapView))
        addGestureRecognizer(tap)
        tap.numberOfTapsRequired = 1
        
        addSubview(placeHolder)
        placeHolder.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        placeHolder.contentMode = .scaleToFill
        placeHolder.autoresizingMask = .flexibleWidth
        
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.width.height.equalTo(40)
        }
        activityIndicator.color = .white
        activityIndicator.layer.zPosition = LayerHierachy.top.rawValue
        
        addSubview(fullScreenBGView)
        fullScreenBGView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        fullScreenBGView.backgroundColor = .black
        fullScreenBGView.isHidden = true
        sendSubview(toBack: fullScreenBGView)
        fullScreenBGView.layer.zPosition = -10
    }
    
    override public func removeFromSuperview() {
        super.removeFromSuperview()
        didMoveOffScreen()
    }
    
    func addPlaybackControlView() {
        guard let safePlaybackBarView = playbackBarView as? UIView else { return } // cannot complete playback view with no playback controls
        addSubview(safePlaybackBarView)
        
        switch playbackBarView!.theme {
        case ToolBarTheme.normal:
            safePlaybackBarView.snp.makeConstraints { (make) in
                make.edges.equalTo(self)
            }
            
            safePlaybackBarView.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
            safePlaybackBarView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .vertical)
        default:
            //TODO: Add support for custom theme positioning & constraint layout
            break
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
    
    func reuseInCell() {
        self.placeHolder.image = nil 
        self.playerLayer = nil
        self.playbackBarView = nil
        presenter?.reuseInCell()
    }
    
    func showPlaceholder() {
        placeHolder.isHidden = false
    }
    
    func reloadInterface(with playerLayer: AVPlayerLayer) {
        self.playerLayer = playerLayer
        playerLayer.frame = self.bounds
        playerLayer.needsDisplayOnBoundsChange = true
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        playerLayer.zPosition = -1.0
        DispatchQueue.main.async {
            self.layer.insertSublayer(playerLayer, at: 0)
            self.placeHolder.isHidden = true
        }
    }
    
    func reloadInterfaceWithoutPlayerlayer() {
        self.playerLayer = nil
        showPlaceholder()
        guard let playbackView = playbackBarView as? UIView else { return }
        bringSubview(toFront: playbackView)
    }
    
    func makeFullScreen() {
        VideoViewAnimator.animateToFullScreen(self)
    }
    
    func makeNormalScreen() {
        VideoViewAnimator.animateToNormalScreen(self)
    }
}
