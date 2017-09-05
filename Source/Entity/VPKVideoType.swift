//
//  VPKVideoType
//  VideoPlaybackKit
//
//  Created by Sonam on 7/20/17.
//  Copyright © 2017 ustwo. All rights reserved.
//
import Foundation

// The data model that represents a local or remote video file. 
// parameters:
/// --- remote: A remote video url hosted on a server 
            /// - url: URL string for remote vidoe url
            /// - placeholderURLName - remote image url 

/// --- local: A local video file located in the project
        /// - videoPathName: path to local file
        /// - fileType - video file type (.mp4, .mov)
        /// - placeholderImageName: name of local image file

public enum VPKVideoType {
    
    case remote(url: String, placeholderURLName: String)
    case local(videoPathName: String, fileType: String, placeholderImageName: String)
    
    var videoUrl: URL? {
        switch self {
        case let .local(videoPathName: aName, fileType: aType, placeholderImageName: _) where Bundle.main.path(forResource: aName, ofType: aType) != nil:
            return URL(fileURLWithPath: Bundle.main.path(forResource: aName, ofType: aType)!)
        case let .remote(url: remoteUrlName, placeholderURLName: _) where URL(string: remoteUrlName) != nil:
            return URL(string: remoteUrlName)
        default:
            return nil
        }
    }
}
