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
    
    public init() {
        //Intentionally left empty to provide public access
    }
    
    //Feed
    public static func vpk_buildViewInCell(for videoType: VPKVideoType, at indexPath: NSIndexPath, with playbackBarTheme: ToolBarTheme = .normal, completion viewCompletion: VideoViewClosure) {
        
        let interactor = VPKVideoPlaybackInteractor(entity: videoType)
        
        let presenter: VPKVideoPlaybackPresenterProtocol & VPKVideoPlaybackInteractorOutputProtocol = VPKVideoPlaybackPresenter(with: false, showInCell: nil, playbackTheme: playbackBarTheme)
        
        viewCompletion(VPKDependencyManager.videoView(with: interactor, and: presenter))
        
    }
    
    //Single View
    public static func vpk_buildVideoView(for videoType: VPKVideoType, shouldAutoplay autoPlay: Bool = false, playbackBarTheme playbackTheme: ToolBarTheme = .normal, completion viewCompletion: (VPKVideoView) -> ()) {
        
        let interactor = VPKVideoPlaybackInteractor(entity: videoType)
        
        let presenter: VPKVideoPlaybackPresenterProtocol & VPKVideoPlaybackInteractorOutputProtocol = VPKVideoPlaybackPresenter(with: autoPlay, showInCell: nil, playbackTheme: playbackTheme)
        
        
        viewCompletion(VPKDependencyManager.videoView(with: interactor, and: presenter))
    }
}

class VPKDependencyManager: VPKDependencyManagerProtocol {
    
    static func videoView(with interactor: VPKVideoPlaybackInteractorProtocol & VPKVideoPlaybackInteractorInputProtocol, and presenter: VPKVideoPlaybackPresenterProtocol & VPKVideoPlaybackInteractorOutputProtocol) -> VPKVideoView {
        
        let videoView = VPKVideoView(frame: .zero)
        let playbackBarView: VPKPlaybackControlViewProtocol = VPKPlaybackControlView(theme: presenter.playbackTheme ?? .normal)
        let videoPlaybackManager: VPKVideoPlaybackManagerInputProtocol & VPKVideoPlaybackManagerOutputProtocol & VPKVideoPlaybackManagerProtocol = VPKVideoPlaybackManager.shared
        
        //Dependency setup
        presenter.interactor = interactor
        interactor.presenter = presenter
        videoView.presenter = presenter
        videoView.playbackBarView = playbackBarView
        presenter.playbackBarView = playbackBarView
        playbackBarView.presenter = presenter
        presenter.videoView = videoView
        interactor.playbackManager = videoPlaybackManager
        
        return videoView
    }
}
