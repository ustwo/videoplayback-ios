//
//  VPKVideoPlaybackBuilder.swift
//  VideoPlaybackKit
//
//  Created by Sonam on 4/21/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import UIKit

public typealias VideoViewClosure = (_ view: VPKVideoView) -> ()
public typealias TimeClosure = (_ time: TimeInterval) -> ()
public typealias StartWithDurationClosure = (_ duration: TimeInterval) -> ()
public typealias CompletionClosure = () -> ()

public class VPKVideoPlaybackBuilder: VPKVideoPlaybackBuilderProtocol {
    
    //Feed (auto-play)
    
    
    //Feed (not auto-play, tap to play)
   public static func vpk_buildInFeedFor(_ videoType: VPKVideoType, atIndexPath indexPath: NSIndexPath, with playbackBarTheme: ToolBarTheme = .normal, completion viewCompletion: VideoViewClosure) {
        
        let presenter: VPKVideoPlaybackPresenterProtocol & VPKVideoPlaybackInteractorOutputProtocol = VPKVideoPlaybackPresenter(videoType: videoType, withAutoplay: false, showInCell: indexPath, playbackTheme: playbackBarTheme)
        viewCompletion(VPKDependencyManager.setupDependencies(presenter: presenter))
    }

    //Single View
    public static func vpk_buildModuleFor(_ videoType: VPKVideoType, shouldAutoplay autoPlay: Bool = false, playbackBarTheme playbackTheme: ToolBarTheme = .normal, completion viewCompletion: (VPKVideoView) -> ()) {
        
        let presenter: VPKVideoPlaybackPresenterProtocol & VPKVideoPlaybackInteractorOutputProtocol = VPKVideoPlaybackPresenter(videoType: videoType, withAutoplay: autoPlay, showInCell: nil, playbackTheme: playbackTheme)
        viewCompletion(VPKDependencyManager.setupDependencies(presenter: presenter))
    }
}

internal class VPKDependencyManager: VPKDependencyManagerProtocol {
    
    static func setupDependencies(presenter: VPKVideoPlaybackInteractorOutputProtocol & VPKVideoPlaybackPresenterProtocol) -> VPKVideoView {
        
        let videoView = VPKVideoView(frame: .zero)
        let playbackBarView: VPKPlaybackControlViewProtocol = VPKPlaybackControlView(theme: presenter.playbackTheme ?? .normal)
        let interactor : VPKVideoPlaybackInteractorInputProtocol = VPKVideoPlaybackInteractor()
        let videoPlaybackManager: VPKVideoPlaybackManagerInputProtocol & VPKVideoPlaybackManagerOutputProtocol & VPKVideoPlaybackManagerProtocol = VPKVideoPlaybackManager.shared
        
        //Dependency setup
        videoView.presenter = presenter
        videoView.playbackBarView = playbackBarView
        presenter.playbackBarView = playbackBarView
        playbackBarView.presenter = presenter
        
        presenter.videoView = videoView
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.playbackManager = videoPlaybackManager
        
        return videoView
    }
}
