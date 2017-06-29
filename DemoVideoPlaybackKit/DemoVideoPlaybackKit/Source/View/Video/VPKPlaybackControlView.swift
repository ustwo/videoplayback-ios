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
    
    var theme: ToolBarTheme = .normal
    var progressValue: Float = 0.0 {
        didSet {
            DispatchQueue.main.async {
                self.playbackProgressSlider.value = self.progressValue   
            }
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
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        playbackProgressSlider.dataSource = self
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        switch theme {
        case .normal:
            setupDefaultTheme()
            setupNormalLayout()
        case let .transparent(backgroundColor: bgColor, foregroundColor: fgColor, alphaValue: alpha):
            setupTransparentThemeWith(bgColor, foreground: fgColor, atTransparency: alpha)
            setupNormalLayout()
        }
    }
    
    private func setupTransparentThemeWith(_ background: UIColor, foreground fg: UIColor, atTransparency alphaValue: CGFloat) {
        alpha = CGFloat(alphaValue)
        backgroundColor = background
        playbackProgressSlider.backgroundColor = fg
        playbackProgressSlider.popUpViewAnimatedColors = [fg, background, UIColor.white]
    }
    
    private func setupDefaultTheme() {
        backgroundColor = VPKColor.backgroundiOS11Default.rgbColor
        layer.borderColor = VPKColor.borderiOS11Default.rgbColor.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 16.0
        isUserInteractionEnabled = true
    }
    
    private func setupNormalLayout() {
        
        let blurContainer = UIView(frame: .zero)
        addSubview(blurContainer)
        blurContainer.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        blurContainer.backgroundColor = .clear
        blurContainer.isUserInteractionEnabled = true
        blurContainer.clipsToBounds = true
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurContainer.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.clipsToBounds = true
        blurContainer.layer.cornerRadius = self.layer.cornerRadius
    
        addSubview(playPauseButton)
        playPauseButton.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(8.0)
            make.centerY.equalTo(self)
            make.height.width.equalTo(30)
        }
        playPauseButton.setBackgroundImage(UIImage(named: PlayerState.paused.buttonImageName), for: .normal)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        
        addSubview(expandButton)
        expandButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.width.height.equalTo(30)
            make.right.equalTo(self.snp.right).offset(-8)
        }
        expandButton.setBackgroundImage(#imageLiteral(resourceName: "fullScreenDefault"), for: .normal)
        expandButton.addTarget(self, action: #selector(didTapExpandView), for: .touchUpInside)
        expandButton.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)


        addSubview(playbackProgressSlider)
        playbackProgressSlider.snp.makeConstraints { (make) in
            make.left.equalTo(playPauseButton.snp.right).offset(8.0)
            make.right.equalTo(expandButton.snp.left).offset(-8.0)
            make.centerY.equalTo(self)
            make.height.equalTo(5.0)
        }
        playbackProgressSlider.addTarget(self, action: #selector(didScrub), for: .valueChanged)
        playbackProgressSlider.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        
        playbackProgressSlider.textColor = VPKColor.borderiOS11Default.rgbColor
        playbackProgressSlider.backgroundColor = VPKColor.timeSliderBackground.rgbColor
        playbackProgressSlider.popUpViewColor = .white
    }
}

extension VPKPlaybackControlView: ASValueTrackingSliderDataSource {
    
    public func slider(_ slider: ASValueTrackingSlider!, stringForValue value: Float) -> String! {
        return presenter?.formattedProgressTime(from: TimeInterval(value))
    }
}

extension VPKPlaybackControlView: VPKPlaybackControlViewProtocol {
    
    
    func showDurationWith(_ time: String) {
        
    }
    
    func setMaximumDurationIn(_ seconds: Float) {
        
    }

    func updateTimePlayingCompletedTo(_ time: Float) {
        progressValue = time
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
