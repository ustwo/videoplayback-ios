//
//  Requests.swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 7/6/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import AVFoundation



protocol Request: class {
    var resourceUrl: URL {get}
    var loadingRequest: AVAssetResourceLoadingRequest {get}
    func cancel()
}

class ContentInfoRequest: Request {
    
    let resourceUrl: URL
    let loadingRequest: AVAssetResourceLoadingRequest
    let infoRequest: AVAssetResourceLoadingContentInformationRequest
    let task: URLSessionTask
    
    init(resourceUrl: URL, loadingRequest: AVAssetResourceLoadingRequest, infoRequest: AVAssetResourceLoadingContentInformationRequest, task: URLSessionTask) {
        self.resourceUrl = resourceUrl
        self.loadingRequest = loadingRequest
        self.infoRequest = infoRequest
        self.task = task
    }
    
    func cancel() {
        task.cancel()
        if !loadingRequest.isCancelled && !loadingRequest.isFinished {
            loadingRequest.finishLoading()
        }
    }
    
}

class DataRequest: Request {
    
    let resourceUrl: URL
    let loadingRequest: AVAssetResourceLoadingRequest
    let dataRequest: AVAssetResourceLoadingDataRequest
    let loader: VPKVideoRequestDownloader
    
    init(resourceUrl: URL, loadingRequest: AVAssetResourceLoadingRequest, dataRequest: AVAssetResourceLoadingDataRequest, loader: VPKVideoRequestDownloader) {
        self.resourceUrl = resourceUrl
        self.loadingRequest = loadingRequest
        self.dataRequest = dataRequest
        self.loader = loader
    }
    
    func cancel() {
        loader.cancel()
        if !loadingRequest.isCancelled && !loadingRequest.isFinished {
            loadingRequest.finishLoading()
        }
    }
}

extension AVAssetResourceLoadingDataRequest {
    var byteRange: ByteRange {
        let lowerBound = requestedOffset
        let upperBound = (lowerBound + requestedLength - 1)
        return (lowerBound..<upperBound)
    }
}
