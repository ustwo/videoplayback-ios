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
public typealias CompletionClosure = () -> ()


public class VPKVideoPlaybackBuilder: VPKVideoPlaybackBuilderProtocol {
    
    public static func vpk_buildModuleFor(_ videoType: VPKVideoType, withPlaceholder placeHolderName: String, shouldAutoplay autoPlay: Bool = false, shouldReuseInCell isInCell: Bool = false, completion viewCompletion: VideoViewClosure) {
        
        let presenter:VPKVideoPlaybackPresenterProtocol & VPKVideoPlaybackInteractorOutputProtocol = VPKVideoPlaybackPresenter(videoType: videoType, withPlaceholder: placeHolderName, withAutoplay: autoPlay, showInCell: isInCell)
        viewCompletion(VPKDependencyManager.setupDependencies(presenter: presenter))
    }
    
}

internal class VPKDependencyManager: VPKDependencyManagerProtocol {
    
    static func setupDependencies(presenter: VPKVideoPlaybackInteractorOutputProtocol & VPKVideoPlaybackPresenterProtocol) -> VPKVideoView {
        
        let videoView = VPKVideoView(frame: .zero)
        let playbackBarView: VPKPlaybackControlViewProtocol = VPKPlaybackControlView(theme: .normal) //TODO: ADD THEME TO BUILDER *make dynamic*
        let interactor : VPKVideoPlaybackInteractorInputProtocol = VPKVideoPlaybackInteractor()
        let videoPlaybackManager: VPKVideoPlaybackManagerInputProtocol & VPKVideoPlaybackManagerOutputProtocol = VPKVideoPlaybackManager()
        
        //Dependency setup
        videoView.presenter = presenter
        videoView.playbackBarView = playbackBarView
        playbackBarView.presenter = presenter
        
        presenter.playbackBarView = playbackBarView
        presenter.videoView = videoView
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.playbackManager = videoPlaybackManager
        
        return videoView
    }
}
