//
//  VPKVideoToolBarView.swift
//  VideoPlaybackKit
//
//  Created by Sonam on 4/21/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import UIKit

public class VPKPlaybackControlView: UIView {
    
    //Protocol
    weak var presenter: VPKVideoPlaybackPresenterProtocol?
    var theme: ToolBarTheme? = .normal
    
    //Private
    fileprivate var playPauseButton = UIButton(frame: .zero)
    private var scrubber = UISlider(frame: .zero)
    private var fullScreen = UIButton(frame: .zero)

    
    convenience init(theme: ToolBarTheme) {
        self.init(frame: .zero)
        self.theme = theme
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        guard let safeTheme = theme else { return }
        switch safeTheme {
        case .normal:
            setupNormalLayout()
        default:
            return
        }
    }
    
    private func setupNormalLayout() {
        backgroundColor = .purple
        isUserInteractionEnabled = true
        
        addSubview(playPauseButton)
        playPauseButton.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(8.0)
            make.centerY.equalTo(self)
            make.height.width.equalTo(40)
        }
        
        playPauseButton.setBackgroundImage(UIImage(named: PlayerState.paused.buttonImageName), for: .normal)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
    }
}

extension VPKPlaybackControlView: VPKPlaybackControlViewProtocol {
    
    func didTapExpandView() {
        presenter?.didExpand()
    }
    
    func toggleActionButton(_ imageName: String) {
        playPauseButton.setBackgroundImage(UIImage(named: imageName), for: .normal)
    }
    
    func didTapPlayPause() {
        presenter?.didTapVideoView()
    }
}
