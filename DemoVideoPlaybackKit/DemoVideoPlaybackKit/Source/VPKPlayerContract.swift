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


//***** REFACTOR ATTEMPT *****************

protocol VPKVideoViewProtocol: class {
    var presenter: VPKVideoPlaybackPresenterProtocol? { get set }
    var placeHolderName: String? { get set }
    var viewWillAppearClosure: CompletionClosure? { get set }

    // PRESENTER -> VIEW
    func reuseInCell(_ shouldReuse: Bool)
    func reloadInterface(with playerLayer: AVPlayerLayer)
    func didTapView()
    func didMoveOffScreen()
    
}

protocol VPKVideoPlaybackBuilderProtocol: class {
    static func createVideoPlaybackModule() -> VPKVideoView
}

//*** Presenter
protocol VPKVideoPlaybackPresenterProtocol: class {
    
    var videoView: VPKVideoViewProtocol? { get set }
    var interactor: VPKVideoPlaybackInteractorInputProtocol? { get set }
    
    // VIEW -> PRESENTER
    func viewDidLoad()
    func didMoveOffScreen()
    func didTapVideoView()
}

//*** Interactor
protocol VPKVideoPlaybackInteractorInputProtocol: class  {
    
    var presenter: VPKVideoPlaybackInteractorOutputProtocol? { get set }
    var playbackManager: VPKVideoPlaybackManagerInputProtocol? { get set }

    // PRESENTER -> INTERACTOR
    func didTapVideo(videoURL: URL)
    func didScrub()
    func didToggleViewExpansion()
    func didMoveOffScreen()
}

protocol VPKVideoPlaybackInteractorOutputProtocol: class  {
    
    //INTERACTOR --> PRESENTER
    func onVideoLoadSuccess(_ playerLayer: AVPlayerLayer)
    func onVideoLoadFail(_ error: String)
    func onStateChange(_ startState: PlayerState, to endState: PlayerState)
}

//** Manager

protocol VPKVideoPlaybackManagerInputProtocol: class {
    var  playerLayerClosure: LayerClosure? { get set }
    func didSelectVideoUrl(_ url: URL)
    func didMoveOffScreen()
}
