//
//  VPKPlayerBuilder.swift
//  VideoPlaybackKit
//
//  Created by Sonam on 4/21/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation

public protocol VPKPlayerBuilder {
    func build(videoURL: String, placeHolderImageURL: String) -> VPKVideoView
    
}
