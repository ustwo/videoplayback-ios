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
    var viewWillAppearClosure: CompletionClosure?
    var placeHolderName: String = "TODO_Default_image" {
        didSet {
            guard let image = UIImage(named: placeHolderName) else { return }
            placeHolder.image = image
            layoutIfNeeded()
        }
    }

    //private
    private let expandButton = UIButton()
    private let activityIndicator = UIActivityIndicatorView(frame: .zero)
    fileprivate let actionButton = UIButton()
    fileprivate let placeHolder = UIImageView(frame: .zero)
    fileprivate var playerLayer: AVPlayerLayer?
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
        
        addSubview(actionButton)
        actionButton.snp.makeConstraints { (make) in
            make.top.equalTo(placeHolder.snp.bottom).offset(10)
            make.centerX.equalTo(placeHolder)
            make.bottom.equalTo(self)
            make.width.height.equalTo(40)
        }
        actionButton.addTarget(self, action: #selector(didTapView), for: .touchUpInside)
        actionButton.setTitle("Play", for: .normal)
        actionButton.setTitleColor(.lightGray, for: .highlighted)
        actionButton.backgroundColor = .purple
        actionButton.layer.zPosition = LayerHierachy.middle.rawValue
        
        addSubview(expandButton)
        expandButton.setTitle("Expand/Collapse", for: .normal)
        expandButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-8.0)
            make.bottom.equalTo(self.snp.bottom).offset(8.0)
        }
        expandButton.sizeToFit()
        expandButton.backgroundColor = .purple
        expandButton.setTitleColor(.lightGray, for: .highlighted)
        expandButton.addTarget(self, action: #selector(didTapExpandView), for: .touchUpInside)
        
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
    
    func didTapExpandView() {
        presenter?.didExpand()
    }
    
    func reuseInCell(_ shouldReuse: Bool) {
        
    }
    
    func toggleActionButtonTitleTo(_ title: String) {
        actionButton.setTitle(title, for: .normal)
    }
    
    func showPlaceholder() {
        placeHolder.isHidden = false
    }
    
    func reloadInterface(with playerLayer: AVPlayerLayer) {
        self.playerLayer = playerLayer
        playerLayer.frame = placeHolder.bounds
        playerLayer.needsDisplayOnBoundsChange = true
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        playerLayer.zPosition = LayerHierachy.top.rawValue
        layer.insertSublayer(playerLayer, at: 0)
        placeHolder.isHidden = true        
    }
    
    func makeFullScreen() {
        VideoViewAnimator.animateToFullScreen(self)
    }
    
    func makeNormalScreen() {
        
    }
}
