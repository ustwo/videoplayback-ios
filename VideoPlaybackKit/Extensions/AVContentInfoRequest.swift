//
//  AVContentInfoRequest.swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 7/6/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import AVFoundation
import MobileCoreServices

internal extension AVAssetResourceLoadingContentInformationRequest {
    
    func update(with response: URLResponse) {
        
        if let response = response as? HTTPURLResponse {
            
            contentLength = response.expectedContentLength
            
            if let acceptRanges = response.allHeaderFields["Accept-Ranges"] as? String,
                acceptRanges == "bytes"
            {
                isByteRangeAccessSupported = true
            } else {
                isByteRangeAccessSupported = false
            }
        }
        else {
            assertionFailure("Invalid URL Response.")
        }
    }
    
}
