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

typealias LayerClosure = (_ layer: AVPlayerLayer) -> ()

//***PUBLIC *** 

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

/*
 ***** VIPER FRAMEWORK PROTOCOL CONTRACT ******
 */


//*** View
//*
//*
protocol VPKVideoViewProtocol: class {
    var presenter: VPKVideoPlaybackPresenterProtocol? { get set }
    var playbackBarView: VPKPlaybackControlViewProtocol? { get set }

    var localPlaceHolderName: String { get set }
    var remotePlaceHolderURL: URL? { get set }
    var viewWillAppearClosure: CompletionClosure? { get set }
    var playerLayer: AVPlayerLayer? { get set }
    
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

protocol VPKViewInCellProtocol: class  {
    var videoView: VPKVideoView? { get set }
    func prepareForVideoReuse()
}

extension VPKViewInCellProtocol where Self: UITableViewCell {
    func prepareForVideoReuse() {
        videoView?.reuseInCell()
    }
}

protocol VPKPlaybackControlViewProtocol: class {
    var presenter: VPKVideoPlaybackPresenterProtocol? { get set } //weak
    var theme: ToolBarTheme? { get set }
    var maximumSeconds: Float { get set }
    var progressValue: Float { get set }


    func didTapExpandView()
    func didTapPlayPause()
    
    func toggleActionButton(_ imageName: String)
    func showDurationWith(_ time: String)
    func updateTimePlayingCompletedTo(_ time: Float)
    func didScrub()
}


//*** Builder
//*
//*

public protocol VPKBuildInCellProtocol: class {
    var videoModel: VPKVideoType { get set }

    static func build(videoURL: String, with placeHolderImageURL: String, shouldAutoplay autoPlay: Bool) -> VPKVideoView
}

public protocol VPKVideoPlaybackBuilderProtocol: class {
    
    //Single View
    static func vpk_buildModuleFor(_ videoType: VPKVideoType, shouldAutoplay autoPlay: Bool, playbackBarTheme playbackTheme: ToolBarTheme, completion viewCompletion: VideoViewClosure)
    
    //View in Feed
    static func vpk_buildVideoInFeedModuleFor(_ videoType: VPKVideoType, atIndexPath indexPath: NSIndexPath, shouldAutoPlayTop autoPlay: Bool, with playbackTheme: ToolBarTheme, completion viewCompletion: VideoViewClosure)
}

protocol VPKDependencyManagerProtocol {
    static func setupDependencies(presenter: VPKVideoPlaybackInteractorOutputProtocol &  VPKVideoPlaybackPresenterProtocol) -> VPKVideoView
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
    
    var videoType: VPKVideoType { get set }
    var shouldAutoplay: Bool? { get set } // if nil defaults to false
    var indexPath: NSIndexPath? { get set } //if nil defaults to false
    
    init(videoType: VPKVideoType, withAutoplay shouldAutoplay: Bool, showInCell indexPath: NSIndexPath?, playbackTheme theme: ToolBarTheme)
    
    // VIEW -> PRESENTER
    func reuseInCell()
    func viewDidLoad()
    func didMoveOffScreen()
    func didTapVideoView()
    func didExpand()
    func didScrubTo(_ value: TimeInterval)
    func formattedProgressTime(from seconds: TimeInterval) -> String
}

//*** Interactor
//*
//* 
protocol VPKVideoPlaybackInteractorInputProtocol: class  {
    
    var presenter: VPKVideoPlaybackInteractorOutputProtocol? { get set }
    var playbackManager: (VPKVideoPlaybackManagerInputProtocol & VPKVideoPlaybackManagerOutputProtocol & VPKVideoPlaybackManagerProtocol)? { get set }


    // PRESENTER -> INTERACTOR
    func didTapVideo(videoURL: URL, at indexPath: NSIndexPath?)
    func didScrubTo(_ timeInSeconds: TimeInterval)
    func didToggleViewExpansion()
    func didMoveOffScreen()
    func didReuseInCell()
}

protocol VPKVideoPlaybackInteractorOutputProtocol: class  {
    
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

protocol VPKVideoPlaybackManagerOutputProtocol: class {
    var onPlayerLayerClosure: LayerClosure? { get set }
    var onStartPlayingWithDurationClosure: StartWithDurationClosure? { get set }
    var onStopPlayingClosure: CompletionClosure? { get set }
    var onDidPlayToEndClosure: CompletionClosure? { get set }
    var onTimeDidChangeClosure: TimeClosure? { get set }
    
}

protocol VPKVideoPlaybackManagerInputProtocol: class {
    func didSelectVideoUrl(_ url: URL)
    func didMoveOffScreen()
    func didScrubTo(_ seconds: TimeInterval)
    func didReuseInVideoCell()
}
