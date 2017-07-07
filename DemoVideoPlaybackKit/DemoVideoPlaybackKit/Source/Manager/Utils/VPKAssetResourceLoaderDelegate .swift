//
//  VPKAssetResourceLoaderDelegate .swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 7/6/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import Foundation
import AVFoundation
import PINCache
import Alamofire


//Strongly influenced by: https://github.com/jaredsinclair/sodes-audio-example/blob/master/Sodes/SodesAudio/ResourceLoaderDelegate.swift

protocol ResourceLoaderNotifierDelegate: class {
    func resourceLoaderDelegate(_ delegate: ResourceLoaderNotifierDelegate, didEncounter error: Error?)
    func resourceLoaderDelegate(_ delegate: ResourceLoaderNotifierDelegate, didUpdateLoadedByteRanges ranges: [ByteRange])
}



///-----------------------------------------------------------------------------
/// ResourceLoaderDelegate
///-----------------------------------------------------------------------------
/// Custom AVAssetResourceLoaderDelegate which stores downloaded audio data to
/// re-usable scratch files on disk. This class thus allows an audio file to be
/// streamed across multiple app sessions with the least possible amount of
/// redownloaded data.
///
/// ResourceLoaderDelegate does not currently keep data for more than one
/// resource at a time. If the user frequently changes audio sources this class
/// will be of limited benefit. 

class VPKAssetResourceLoaderDelegate: NSObject, AVAssetResourceLoaderDelegate {

    internal enum ErrorStatus {
        case none
        case error(Error?)
    }
    
    // MARK: Internal Properties

    /// The ResourceLoaderDelegate's, err..., delegate.
    internal weak var delegate: ResourceLoaderNotifierDelegate?
    
    /// The current error status
    internal fileprivate(set) var errorStatus: ErrorStatus = .none
    
    // MARK: Private Properties (Immutable)
    
    /// Used to store the URL for the most-recently used video source.
    fileprivate let defaults: UserDefaults
    
    /// The directory where all scratch file subdirectories are stored.
    fileprivate let resourcesDirectory: URL
    
    /// A loading scheme used to ensure that the AVAssetResourceLoader routes
    /// its requests to this class.
    fileprivate let customLoadingScheme: String
    
    /// A serial queue on which AVAssetResourceLoader will call delegate methods.
    fileprivate let loaderQueue: DispatchQueue
    
    
    // MARK: Private Properties (Mutable)
    
    /// The current resource loader. We can't assume that the same one will
    /// always be used, so keeping a reference to it here helps us avoid
    /// cross-talk between audio sessions.
    fileprivate var currentAVAssetResourceLoader: AVAssetResourceLoader?
    
    
    //The current url used in the data task
    fileprivate var originalURL: URL?
    
    /// The request wrapper object containg references to all the info needed
    /// to process the current AVAssetResourceLoadingRequest.
    fileprivate var currentRequest: Request? {
        didSet {
            // Under conditions that I don't know how to reproduce, AVFoundation
            // sometimes fails to cancel previous requests that cover ~90% of
            // of the previous. It seems to happen when repeatedly seeking, but
            // it could have been programmer error. Either way, in my testing, I
            // found that cancelling (by finishing early w/out data) the
            // previous request, I can keep the activity limited to a single
            // request and vastly improve loading times, especially on poor
            // networks.
            oldValue?.cancel()
        }
    }
    
    // MARK: Init/Deinit
    internal init(customLoadingScheme: String, resourcesDirectory: URL, defaults: UserDefaults) {

        self.defaults = defaults
        self.resourcesDirectory = resourcesDirectory
        self.customLoadingScheme = customLoadingScheme
        self.loaderQueue = DispatchQueue(label: "com.VPKPlayback.ResourceLoaderDelegate.loaderQueue")
        super.init()
    }
    
    //MARK: Public Methods
    
    // MARK: Internal Methods
    
    
    
    /// Prepares an AVURLAsset, configuring the resource loader's delegate, etc.
    /// This method returns nil if the receiver cannot prepare an asset that it
    /// can handle.
    internal func prepareAsset(for url: URL) -> AVURLAsset? {
        self.originalURL = url
        
        guard let redirectUrl = url.convertToRedirectURL(prefix: customLoadingScheme) else {
            print ("Bad url: \(url)\nCould not convert the url to a redirect url.")
            return nil
        }
        
        currentAVAssetResourceLoader = nil
        let asset = AVURLAsset(url: redirectUrl)
        asset.resourceLoader.setDelegate(self, queue: loaderQueue)
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).response(queue: loaderQueue) { (response) in
            
            
        }
        
        return asset
    }
    
    
    
    //MARK: AVAssetResourceLoaderDelegate
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        
        print("resource loader delegate called")
        
        //Complete all asynchronous work here
        if let _ = loadingRequest.contentInformationRequest {
            
            //local file request
            return handleContentInfoRequest(for: loadingRequest)
            
        } else if let _ = loadingRequest.dataRequest {
            
            //remote file request
            return handleDataRequest(for: loadingRequest)
            
        } else {
            return false
        }
        return true
    }
    
    private func handleContentInfoRequest(for loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        
        print("Will attempt to handle content info request.")
        
        guard let infoRequest = loadingRequest.contentInformationRequest else { return false}
        guard let redirectURL = loadingRequest.request.url else { return false }
        guard let originalURL = redirectURL.convertFromRedirectURL(prefix: customLoadingScheme) else { return false }
//        guard let scratchFileInfo = self.scratchFileInfo else {return false}
        
        print("Will handle content info request.")
        
        let request: URLRequest = {
            var request = URLRequest(url: originalURL)
            if let dataRequest = loadingRequest.dataRequest {
                // Nota Bene: Even though the content info request is often
                // accompanied by a data request, **do not** invoke the data
                // requests `respondWithData()` method as this will put the
                // asset loading request into an undefined state. This isn't
                // documented anywhere, but beware.
                request.setByteRangeHeader(for: dataRequest.byteRange)
            }
            return request
        }()
        
        let task = URLSession.shared.downloadTask(with: request) { (tempUrl, response, error) in
            
            // I'm using strong references to `self` because I don't know if
            // AVFoundation could recover if `self` became nil before cancelling
            // all active requests. Retaining `self` here is easier than the
            // alternatives. Besides, this class has been designed to accompany
            // a singleton VPKPlaybackManager
            
            self.loaderQueue.async {
                
                // Bail early if the content info request was cancelled.
                
                guard !loadingRequest.isCancelled else
                {
                    print("Bailing early because the loading request was cancelled.")
                    return
                }
                
                guard let request = self.currentRequest as? ContentInfoRequest,
                    loadingRequest === request.loadingRequest else
                {
                    print("Bailing early because the loading request has changed.")
                    return
                }
                
//                guard let delayedScratchFileInfo = self.scratchFileInfo,
//                    delayedScratchFileInfo === scratchFileInfo else
//                {
//                    print("Bailing early because the scratch file info has changed.")
//                    return
//                }
                
                if let response = response, error == nil {
                    
                    // Check the Etag and Last-Modified header values to see if
                    // the file has changed since the last cache info was
                    // fetched (if this is the first time we're seeing this
                    // file, the existing info will be blank, which is fine). If
                    // the cached info is no longer valid, wipe the loaded byte
                    // ranges from the metadata and update the metadata with the
                    // new Etag/Last-Modified header values.
                    //
                    // If the content provider never provides cache validation
                    // values, this means we will always re-download the data.
                    //
                    // Note that we're not removing the bytes from the actual
                    // scratch file on disk. This may turn out to be a bad idea,
                    // but for now lets assume that our byte range metadata is
                    // always up-to-date, and that by resetting the loaded byte
                    // ranges here we will prevent future subrequests from
                    // reading byte ranges that have since been invalidated.
                    // This works because DataRequestLoader will not create any
                    // scratch file subrequests if the loaded byte ranges are
                    // empty.
                    
//                    let cacheInfo = response.cacheInfo(using: self.formatter)
//                    if !delayedScratchFileInfo.cacheInfo.isStillValid(comparedTo: cacheInfo) {
//                        delayedScratchFileInfo.cacheInfo = cacheInfo
//                        self.saveUpdatedScratchFileMetaData(immediately: true)
//                        SodesLog("Reset the scratch file meta data since the cache validation values have changed.")
//                    }
                    
                    print("Item completed: content request: \(response)")
                    infoRequest.update(with: response)
                    loadingRequest.finishLoading()
                }
                else {
                    
                    // Do not update the scratch file meta data here since the
                    // request could have failed for any number of reasons.
                    // Let's only reset meta data if we receive a successful
                    // response.
                    
                    print("Failed with error: \(error)")
                    self.finish(loadingRequest, with: error)
                }
                
                if self.currentRequest === request {
                    // Nil-out `currentRequest` since we're done with it, but
                    // only if the value of self.currentRequest didn't change
                    // (since we just called `loadingRequest.finishLoading()`.
                    self.currentRequest = nil
                }
            }
        }
        
        self.currentRequest = ContentInfoRequest(
            resourceUrl: originalURL,
            loadingRequest: loadingRequest,
            infoRequest: infoRequest,
            task: task
        )
        
        task.resume()
        
        return true
        
    }
    
    private func handleDataRequest(for loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        
        return true
    }
    
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        
    }
    
    func finish(_ loadingRequest: AVAssetResourceLoadingRequest, with error: Error?) {
        self.errorStatus = .error(error)
        loadingRequest.finishLoading(with: error as? NSError)
        DispatchQueue.main.async {
            if case .error(_) = self.errorStatus {
                print(error)
                //self.delegate?.resourceLoaderDelegate(self, didEncounter: error)
            }
        }
    }

}


