//
//  VPKVideoToolBarView.swift
//  VideoPlaybackKit
//
//  Created by Sonam on 4/21/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import ASValueTrackingSlider

public class VPKPlaybackControlView: UIView {
    
    //Protocol
    weak var presenter: VPKVideoPlaybackPresenterProtocol?
    var theme: ToolBarTheme? = .normal
    var progressValue: Float = 0.0 {
        didSet {
            playbackProgressSlider.value = progressValue
        }
    }
    var maximumSeconds: Float = 0.0 {
        didSet {
            playbackProgressSlider.maximumValue = maximumSeconds
        }
    }
    
    //Private
    fileprivate var playPauseButton = UIButton(frame: .zero)
    private let fullScreen = UIButton(frame: .zero)
    private let volumeCtrl = MPVolumeView()
    private let expandButton = UIButton(frame: .zero)
    private let timeProgressLabel = UILabel(frame: .zero)
    private let durationLabel = UILabel(frame: .zero)
    fileprivate let playbackProgressSlider = ASValueTrackingSlider(frame: .zero)

    
    convenience init(theme: ToolBarTheme) {
        self.init(frame: .zero)
        self.theme = theme
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        playbackProgressSlider.dataSource = self
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
            make.height.width.equalTo(30)
        }
        
        playPauseButton.setBackgroundImage(UIImage(named: PlayerState.paused.buttonImageName), for: .normal)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        
        addSubview(volumeCtrl)
        volumeCtrl.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-8.0)
            make.height.width.equalTo(50)
            make.centerY.equalTo(self)
        }
        
        addSubview(expandButton)
        expandButton.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-8.0)
            make.centerY.equalTo(self)
            make.width.height.equalTo(30)
        }
        expandButton.setBackgroundImage(#imageLiteral(resourceName: "fullScreenDefault"), for: .normal)
        expandButton.addTarget(self, action: #selector(didTapExpandView), for: .touchUpInside)
        
        addSubview(playbackProgressSlider)
        playbackProgressSlider.snp.makeConstraints { (make) in
            make.left.equalTo(playPauseButton.snp.right).offset(8.0)
            make.right.equalTo(expandButton.snp.left).offset(-8.0)
            make.centerY.equalTo(self)
            make.height.equalTo(10.0)
        }
        playbackProgressSlider.backgroundColor = .white
        playbackProgressSlider.popUpViewAnimatedColors = [UIColor.blue, UIColor.green, UIColor.yellow]
        playbackProgressSlider.addTarget(self, action: #selector(didScrub), for: .valueChanged)
    }
}

extension VPKPlaybackControlView: ASValueTrackingSliderDataSource {
    
    public func slider(_ slider: ASValueTrackingSlider!, stringForValue value: Float) -> String! {
        //USE THIS TO FORMAT the string on the bar
        return String(round(value))
    }
}

extension VPKPlaybackControlView: VPKPlaybackControlViewProtocol {
    
    
    func showDurationWith(_ time: String) {
        
    }
    
    func setMaximumDurationIn(_ seconds: Float) {
        
    }

    func updateTimePlayingCompletedTo(_ time: Float) {
        
    }
    
    func didScrub() {
        #if DEBUG
            print("USER SCRUBBED TO \(playbackProgressSlider.value)")
        #endif
        presenter?.didScrubTo(TimeInterval(playbackProgressSlider.value))
    }
    
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
