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
    
    public static func vpk_buildModuleFor(_ videoType: VPKVideoType, withPlaceholder placeHolderName: String, shouldAutoplay autoPlay: Bool = false, shouldReuseInCell isInCell: Bool = false, playbackBarTheme playbackTheme: ToolBarTheme = .normal, completion viewCompletion: VideoViewClosure) {
        
        let presenter: VPKVideoPlaybackPresenterProtocol & VPKVideoPlaybackInteractorOutputProtocol = VPKVideoPlaybackPresenter(videoType: videoType, withPlaceholder: placeHolderName, withAutoplay: autoPlay, showInCell: isInCell, playbackTheme: playbackTheme)
        viewCompletion(VPKDependencyManager.setupDependencies(presenter: presenter))
    }
    
}

internal class VPKDependencyManager: VPKDependencyManagerProtocol {
    
    static func setupDependencies(presenter: VPKVideoPlaybackInteractorOutputProtocol & VPKVideoPlaybackPresenterProtocol) -> VPKVideoView {
        
        let videoView = VPKVideoView(frame: .zero)
        let playbackBarView: VPKPlaybackControlViewProtocol = VPKPlaybackControlView(theme: presenter.playbackTheme ?? .normal)
        let interactor : VPKVideoPlaybackInteractorInputProtocol = VPKVideoPlaybackInteractor()
        let videoPlaybackManager: VPKVideoPlaybackManagerInputProtocol & VPKVideoPlaybackManagerOutputProtocol = VPKVideoPlaybackManager()
        
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
