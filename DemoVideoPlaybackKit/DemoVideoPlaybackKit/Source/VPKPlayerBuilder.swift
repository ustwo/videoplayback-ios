//
//  VPKPlayerBuilder.swift
//  VideoPlaybackKit
//
//  Created by Sonam on 4/21/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation

public typealias VideoViewClosure = (_ view: VPKVideoView) -> ()

public class VPKPlayerBuilder: NSObject {
   
    //Local video playback
    public static func vpk_buildLocal(_ pathName: String, withType fileType: String, withPlaceHolder placeHolder: String, shouldRueseInCell isInCell: Bool = false, playerViewCompletion completion: VideoViewClosure) {
        
        let presenter = VPKVideoViewPresenter(localFileName: pathName, fileType: fileType, placeHolder: placeHolder)
        completion(presenter.localVideoView())
    }
    
    //Remote video playback
    public static func vpk_build(_ videoURL: String, withPlaceholder placeHolderImageURL: String, shouldReuseInCell isInCell: Bool = false,  playerViewCompletion completion: VideoViewClosure) {
        
        let videoView = VPKVideoView(frame: .zero)
        completion(videoView)        
    }
}
