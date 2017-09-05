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
    fileprivate let timeProgressLabel = UILabel(frame: .zero)
    fileprivate let durationLabel = UILabel(frame: .zero)
    private let skipBackButton = UIButton(frame: .zero)
    private let skipForwardButton = UIButton(frame: .zero)
    private let bottomControlContainer = UIView(frame: .zero)
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
            setupNormalColorTheme()
            setupNormalLayout()
            
        case .custom(bottomBackgroundColor: _, sliderBackgroundColor: _, sliderIndicatorColor: _, sliderCalloutColors: _):
            setupNormalLayout()
            setupCustomColorWith(theme: theme)
        }
    }
    
    private func setupNormalColorTheme() {
        bottomControlContainer.backgroundColor = VPKColor.backgroundiOS11Default.rgbColor
        playbackProgressSlider.textColor = VPKColor.borderiOS11Default.rgbColor
        playbackProgressSlider.backgroundColor = VPKColor.timeSliderBackground.rgbColor
        playbackProgressSlider.popUpViewColor = .white
        
    }
    
    private func setupCustomColorWith(theme: ToolBarTheme) {
        switch theme {
        case let .custom(bottomBackgroundColor: bottomBGColor, sliderBackgroundColor: sliderBGColor, sliderIndicatorColor: sliderIndicatorColor, sliderCalloutColors: calloutColors):
            
            self.bottomControlContainer.backgroundColor = bottomBGColor
            self.playbackProgressSlider.backgroundColor = sliderBGColor
            self.playbackProgressSlider.textColor = sliderIndicatorColor
            self.playbackProgressSlider.popUpViewAnimatedColors = calloutColors
        default:
            break
        }
    }
    
    private func setupNormalLayout() {
        
        isUserInteractionEnabled = true

        addSubview(bottomControlContainer)
        bottomControlContainer.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(6.5)
            make.right.equalTo(self).offset(-6.5)
            make.height.equalTo(47)
            make.bottom.equalTo(self.snp.bottom).offset(-6.5)
        }
        bottomControlContainer.layer.cornerRadius = 16.0
        bottomControlContainer.layer.borderColor = VPKColor.borderiOS11Default.rgbColor.cgColor
        bottomControlContainer.layer.borderWidth = 0.5
        
        let blurContainer = UIView(frame: .zero)
        bottomControlContainer.addSubview(blurContainer)
        blurContainer.snp.makeConstraints { (make) in
            make.edges.equalTo(bottomControlContainer)
        }
        blurContainer.backgroundColor = .clear
        blurContainer.isUserInteractionEnabled = true
        blurContainer.clipsToBounds = true
        
        let blurEffect = self.defaultBlurEffect()
        blurContainer.addSubview(blurEffect)
        blurEffect.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        blurContainer.layer.cornerRadius = bottomControlContainer.layer.cornerRadius
    
        bottomControlContainer.addSubview(playPauseButton)
        playPauseButton.snp.makeConstraints { (make) in
            make.left.equalTo(bottomControlContainer).offset(8.0)
            make.centerY.equalTo(bottomControlContainer)
            make.height.width.equalTo(28)
        }
        playPauseButton.setBackgroundImage(UIImage(named: PlayerState.paused.buttonImageName), for: .normal)
        playPauseButton.contentMode = .scaleAspectFit
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        
        
        bottomControlContainer.addSubview(timeProgressLabel)
        bottomControlContainer.addSubview(playbackProgressSlider)
        
        timeProgressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(playPauseButton.snp.right).offset(8.0)
            make.centerY.equalTo(bottomControlContainer)
            make.right.equalTo(playbackProgressSlider.snp.left).offset(-6.0)
        }
        
        timeProgressLabel.textColor = UIColor(white: 1.0, alpha: 0.75)
        timeProgressLabel.text = "0:00"
        
        bottomControlContainer.addSubview(durationLabel)
        playbackProgressSlider.snp.makeConstraints { (make) in
            make.left.equalTo(timeProgressLabel.snp.right).offset(5.0)
            make.right.equalTo(durationLabel.snp.left).offset(-5.0).priority(1000)
            make.centerY.equalTo(bottomControlContainer)
            make.height.equalTo(5.0)
        }
        playbackProgressSlider.addTarget(self, action: #selector(didScrub), for: .valueChanged)
        playbackProgressSlider.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        playbackProgressSlider.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        
        
        bottomControlContainer.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { (make) in
            make.right.equalTo(bottomControlContainer.snp.right).offset(-8.0)
            make.centerY.equalTo(bottomControlContainer)
        }
        durationLabel.textColor = UIColor(white: 1.0, alpha: 0.75)
        durationLabel.text = "0:00"
        durationLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        durationLabel.setContentHuggingPriority(UILayoutPriorityFittingSizeLevel, for: .horizontal)
        
        
        addSubview(expandButton)
        expandButton.layer.cornerRadius = 16.0
        expandButton.backgroundColor = VPKColor.backgroundiOS11Default.rgbColor
        expandButton.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(8.0)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.top.equalTo(self).offset(8.0)
        }
        expandButton.setBackgroundImage(#imageLiteral(resourceName: "defaultExpand"), for: .normal)
        expandButton.addTarget(self, action: #selector(didTapExpandView), for: .touchUpInside)
        
        bottomControlContainer.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        
        
    }
}

extension VPKPlaybackControlView: ASValueTrackingSliderDataSource {
    
    public func slider(_ slider: ASValueTrackingSlider!, stringForValue value: Float) -> String! {
        return presenter?.formattedProgressTime(from: TimeInterval(value))
    }
}

extension VPKPlaybackControlView: VPKPlaybackControlViewProtocol {
    
    
    func showDurationWith(_ time: String) {
        durationLabel.text = time
        layoutIfNeeded()
    }
    
    func didSkipBack(_ seconds: Float = 15.0) {
        presenter?.didSkipBack(seconds)
    }
    
    func didSkipForward(_ seconds: Float = 15.0) {
        presenter?.didSkipForward(seconds)
    }

    func updateTimePlayingCompletedTo(_ time: String) {
        timeProgressLabel.text = time
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
        
        DispatchQueue.main.async {
            self.playPauseButton.setBackgroundImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    func didTapPlayPause() {
        presenter?.didTapVideoView()
    }
}

extension VPKPlaybackControlView {
    
    func defaultBlurEffect() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.clipsToBounds = true
        return blurEffectView
    }
}
