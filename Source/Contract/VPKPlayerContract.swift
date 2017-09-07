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
import ASValueTrackingSlider

public typealias LayerClosure = (_ layer: AVPlayerLayer) -> ()

///-----------------------------------------------------------------------------
/// VIP FRAMEWORK PROTOCOL CONTRACT ******
//  This contract defines and explains the public protocols for the VIP module to work with your code. Protocols define the neccessary behavior for any class to conform to in order for the module to function correctly. Please make sure to reference default implementations to further understand what is happening in the background
///-----------------------------------------------------------------------------


//** Use Case
//*
//** 
//  You can use this if you want to create seperate interactors that are used to satisfy each use case
//**

protocol VPKMainPlayerUseCase: class {
    func selectVideo()
    func scrubVideo()
    func expandFullScreen()
    func airPlayVideo()
    func controlVolume()
    func doubleTapForCommand()
}

//*** View
/// The video view protocol defines the interface requirements for a view that supports video playback.
protocol VPKVideoViewProtocol: class {
    
    var presenter: VPKVideoPlaybackPresenterProtocol? { get set }
    var playbackBarView: VPKPlaybackControlViewProtocol? { get set }
    var fullScreenBGView: UIView { get set }
    var originalFrame: CGRect? { get set }
    var originalSuperview: UIView { get set }
    
    var localPlaceHolderName: String { get set }
    var activityIndicator: UIActivityIndicatorView { get set }
    var remotePlaceHolderURL: URL? { get set }
    var viewWillAppearClosure: CompletionClosure? { get set }
    var playerLayer: AVPlayerLayer? { get set }
    
    //These methods
    // PRESENTER -> VIEW
    func reuseInCell()
    func reloadInterface(with playerLayer: AVPlayerLayer)
    func showPlaceholder()
    func makeFullScreen()
    func makeNormalScreen()
    func reloadInterfaceWithoutPlayerlayer()
    
    //VIEW -> PRESENTER
    func didTapView()
    func didMoveOffScreen()
}

public protocol VPKViewInCellProtocol: class  {
    var videoView: VPKVideoView? { get set }
    func prepareForVideoReuse()
}

public extension VPKViewInCellProtocol where Self: UITableViewCell {
    func prepareForVideoReuse() {
        videoView?.reuseInCell()
    }
}

protocol VPKPlaybackControlViewProtocol: class {
    var presenter: VPKVideoPlaybackPresenterProtocol? { get set } //weak
    var theme: ToolBarTheme { get set }
    var maximumSeconds: Float { get set }
    var progressValue: Float { get set }
    
    func didTapExpandView()
    func didTapPlayPause()
    func didSkipBack(_ seconds: Float) //defaults to 15
    func didSkipForward(_ seconds: Float) // defaults to 15
    
    func toggleActionButton(_ imageName: String)
    func showDurationWith(_ time: String)
    func updateTimePlayingCompletedTo(_ time: String)
    func didScrub()
}


//*** Builder
//*
//*

public protocol VPKVideoPlaybackBuilderProtocol: class {
    
    //Single View
    static func vpk_buildVideoView(for entity: VPKVideoType, shouldAutoplay autoPlay: Bool, playbackBarTheme playbackTheme: ToolBarTheme, completion viewCompletion: VideoViewClosure)
    
    //View in Feed
    static func vpk_buildViewInCell(for entity: VPKVideoType, at indexPath: NSIndexPath,with playbackBarTheme: ToolBarTheme, completion viewCompletion: VideoViewClosure)
}

protocol VPKDependencyManagerProtocol {
    static func videoView(with interactor: VPKVideoPlaybackInteractorProtocol & VPKVideoPlaybackInteractorInputProtocol, and presenter: VPKVideoPlaybackPresenterProtocol & VPKVideoPlaybackInteractorOutputProtocol) -> VPKVideoView
}

//*** Presenter
//*
//*
protocol VPKVideoPlaybackPresenterProtocol: class {
    
    var videoView: VPKVideoViewProtocol? { get set }
    var playbackBarView: VPKPlaybackControlViewProtocol? { get set }
    var interactor: VPKVideoPlaybackInteractorInputProtocol? { get set }
    var videoSizeState: VideoSizeState? { get set }
    var playbackTheme: ToolBarTheme? { get set }
    var shouldAutoplay: Bool? { get set } // if nil defaults to false
    var indexPath: NSIndexPath? { get set } //if nil defaults to false
    
    init(with autoplay: Bool, showInCell indexPath: NSIndexPath?, playbackTheme theme: ToolBarTheme)
    
    // VIEW -> PRESENTER
    func reuseInCell()
    func viewDidLoad()
    func didMoveOffScreen()
    func didTapVideoView()
    func didExpand()
    func didScrubTo(_ value: TimeInterval)
    func didSkipBack(_ seconds: Float)
    func didSkipForward(_ seconds: Float)
    func formattedProgressTime(from seconds: TimeInterval) -> String
}

//*** Interactor
//*
//*

protocol VPKVideoPlaybackInteractorProtocol: class {
    
    init(entity: VPKVideoType)
}

protocol VPKVideoPlaybackInteractorInputProtocol: class  {
    
    var presenter: VPKVideoPlaybackInteractorOutputProtocol? { get set }
    var videoType: VPKVideoType { get set }
    var remoteImageURL: URL? { get set }
    var localImageName: String? { get set }
    
    var playbackManager: (VPKVideoPlaybackManagerInputProtocol & VPKVideoPlaybackManagerOutputProtocol & VPKVideoPlaybackManagerProtocol)? { get set }
    
    // PRESENTER -> INTERACTOR
    func didTapVideo(videoURL: URL, at indexPath: NSIndexPath?)
    func didScrubTo(_ timeInSeconds: TimeInterval)
    func didSkipBack(_ seconds: Float)
    func didSkipForward(_ seconds: Float)
    func didToggleViewExpansion()
    func didMoveOffScreen()
    func didReuseInCell()
}

protocol VPKVideoPlaybackInteractorOutputProtocol: class  {
    
    var progressTime: TimeInterval { get set }
    
    //INTERACTOR --> PRESENTER
    func onVideoResetPresentation()
    func onVideoLoadSuccess(_ playerLayer: AVPlayerLayer)
    func onVideoLoadFail(_ error: String)
    func onVideoDidStartPlayingWith(_ duration: TimeInterval)
    func onVideoDidStopPlaying()
    func onVideoDidPlayToEnd()
    func onVideoPlayingFor(_ seconds: TimeInterval)
}

//** Player Manager
//*
//*
protocol VPKVideoPlaybackManagerProtocol: class {
    var playerState: PlayerState? { get set }
    var currentVideoUrl: URL? { get set }
    var delegate: VPKVideoPlaybackDelegate? { get set }
    var isPlaying: Bool { get }
    
    func stop()
    func cleanup()
}

public protocol VPKVideoPlaybackManagerOutputProtocol: class {
    var onPlayerLayerClosure: LayerClosure? { get set }
    var onStartPlayingWithDurationClosure: StartWithDurationClosure? { get set }
    var onStopPlayingClosure: CompletionClosure? { get set }
    var onDidPlayToEndClosure: CompletionClosure? { get set }
    var onTimeDidChangeClosure: TimeClosure? { get set }
    
}

public protocol VPKVideoPlaybackManagerInputProtocol: class {
    func didSelectVideoUrl(_ url: URL)
    func didMoveOffScreen()
    func didScrubTo(_ seconds: TimeInterval)
    func didReuseInVideoCell()
}
