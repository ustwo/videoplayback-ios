//
//  VPKPlayerBuilder.swift
//  VideoPlaybackKit
//
//  Created by Sonam on 4/21/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import UIKit

public typealias VideoViewClosure = (_ view: VPKVideoView) -> ()
public typealias CompletionClosure = () -> ()

public enum VPKVideoType {
    case remote(url: String), local(pathName: String, fileType: String)
}

public class VPKPlaybackBuilder: NSObject {
   
    public static func vpk_buildModuleFor(_ videoType: VPKVideoType, withPlaceholder placeHolderName: String, shouldAutoplay autoPlay: Bool = false, shouldReuseInCell isInCell: Bool = false, completion viewCompletion: VideoViewClosure) {
        
        switch videoType {
        case .local(pathName: let name, fileType: let type):
            vpk_buildLocal(name, withType: type
                , withPlaceHolder: placeHolderName, playerViewCompletion: { (videoView) in
                    print("building local")
            })
        case .remote(url: let url):
            vpk_build(url, withPlaceholder: placeHolderName, playerViewCompletion: { (videoView) in
                print("building remote")
            })
        }
    }
    
    //Local video playback
    private static func vpk_buildLocal(_ pathName: String, withType fileType: String, withPlaceHolder placeHolder: String, shouldAutoplay autoPlay: Bool = false,  shouldRueseInCell isInCell: Bool = false, playerViewCompletion completion: VideoViewClosure) {
        
        let presenter = VPKVideoPlaybackPresenter(localFileName: pathName, fileType: fileType, placeHolder: placeHolder, shouldAutoplay: autoPlay) as? VPKVideoPlaybackPresenterProtocol
        
        completion(VPKVideoView())
       // completion(presenter.localVideoView() as! VPKVideoView)
    }
    
    //Remote video playback
    private static func vpk_build(_ videoURL: String, withPlaceholder placeHolderImageURL: String, shouldReuseInCell isInCell: Bool = false,  playerViewCompletion completion: VideoViewClosure) {
        
        let videoView = VPKVideoView(frame: .zero)
        completion(videoView)        
    }
}

public class VPKVideoPlaybackBuilder: VPKVideoPlaybackBuilderProtocol {
    

    static func createVideoPlaybackModule() -> VPKVideoView {
        
        let videoView = VPKVideoView(frame: .zero)
        let presenter: VPKVideoPlaybackPresenterProtocol & VPKVideoPlaybackInteractorOutputProtocol = VPKVideoPlaybackPresenter() as VPKVideoPlaybackInteractorOutputProtocol & VPKVideoPlaybackPresenterProtocol
        let interactor : VPKVideoPlaybackInteractorInputProtocol = VPKVideoPlaybackInteractor()
        let videoPlaybackManager: VPKVideoPlaybackManagerInputProtocol = VPKVideoPlaybackManager()
        
        
        //Dependency setup
        videoView.presenter = presenter
        presenter.videoView = videoView
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.playbackManager = videoPlaybackManager
        
        return videoView
    }
}
