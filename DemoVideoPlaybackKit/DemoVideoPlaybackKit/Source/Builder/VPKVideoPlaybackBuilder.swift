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
        
        viewCompletion(VPKDependencyManager.setupViewWithDependencies(presenter: presenter))        
    }
    
}

internal class VPKDependencyManager: VPKDependencyManagerProtocol {
    
    
    static func setupViewWithDependencies(presenter: VPKVideoPlaybackInteractorOutputProtocol & VPKVideoPlaybackPresenterProtocol) -> VPKVideoView {
        
        let videoView = VPKVideoView(frame: .zero)
        let interactor : VPKVideoPlaybackInteractorInputProtocol = VPKVideoPlaybackInteractor()
        let videoPlaybackManager: VPKVideoPlaybackManagerInputProtocol & VPKVideoPlaybackManagerOutputProtocol = VPKVideoPlaybackManager()
        
        //Dependency setup
        videoView.presenter = presenter
        presenter.videoView = videoView
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.playbackManager = videoPlaybackManager
        
        return videoView
    }
}
