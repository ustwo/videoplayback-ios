//
//  VPKPlayerContract.swift
//  VideoPlaybackKit
//
//  Created by Sonam on 4/24/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

typealias LayerClosure = (_ layer: AVPlayerLayer) -> ()

public enum PlayerState {
    case playing, paused
}


//** Builder
//*
//*
public protocol VPKVideoBuilder {
    func build(videoURL: String, with placeHolderImageURL: String,shouldAutoplay autoPlay: Bool) -> VPKVideoView
}

//** Styling
//*
//*
public protocol Theme {
    var colorTheme: ColorTheme { get }
    var fontTheme: FontTheme { get }
}

public protocol ColorTheme {
    var primaryColor: UIColor { get }
    var secondaryColor: UIColor { get }
    var tertiaryColor: UIColor { get }
}

public protocol FontTheme {
    var title: [String: String] { get }
    var subtitle: [String: String] {get }
    var heading1: [String: String] { get }
    var heading2: [String: String] { get }
    // ...
    
    func titleText(text: String) -> NSAttributedString
    func subtitleText(text: String) -> NSAttributedString
    func heading1Text(text: String) -> NSAttributedString
    func heading2Text(text: String) -> NSAttributedString
    // ...
}

//** Use Case
//*
//*
protocol VPKMainPlayerUseCase: class {
    func selectVideo()
    func scrubVideo()
    func expandFullScreen()
    func airPlayVideo()
    func controlVolume()
    func doubleTapForCommand()
}

//** View
//*
//*
protocol VPKVideoPlayerView: class {
    func showError(_ message: String)
    func loadVideo(_ videoURL: String, withPlaceHolder placeHolderURL: String)
    func setReuseInCell(_ shouldReuseInCell: Bool)
    var  isReusedInCell: Bool? { get set }
}

//** Presenter 
//*
//*
public protocol VPKVideoPlayerPresenter: class {
    func onViewDidLoad()
    func onDidSelectView()
    func onReuseInCell()
    func onError(_ errorMessage: String)
}

public protocol VPKVideoPlayerEventHandler {
    
}

//** Interactor
//*
//*
/*public protocol VPKVideoPlayerInteractor {
    associatedtype VideoPlayerPresenterType: VPKVideoPlayerPresenter
    associatedtype VideoPlayerManagerType: VPKVideoPlayerManager
    var presenter: VPKVideoPlayerPresenter { get }
    var videoPlayerManager: VPKVideoPlayerManager { get }
    func loadVideo(_ videoURL: String, withPlaceholder placeholderURL: String)
}
*/

//** Interactor
//*
//*
protocol VPKVideoPlayerInteractorInput {
    func didTapVideo(videoURL: URL)
    func didScrub()
    func didToggleViewExpansion()
    func didMoveOffScreen()
}


protocol VPKVideoPlayerInteractorOutput {
    func onVideoLoadSuccess(_ playerLayer: AVPlayerLayer)
    func onVideoLoadFail(_ error: String)
    func onStateChange(_ startState: PlayerState, to endState: PlayerState)
}
