//
//  VPKTableViewPrefetchSynchronizer.swift
//  DemoVideoPlaybackKit
//s//  Created by Sonam on 7/5/17.
//  Copyright © 2017 ustwo. All rights reserved.
//


import Foundation
import UIKit

public extension UITableView {
    
    func vpk_setPrefetchOptimizer(for videoItems:[VPKVideoType]) {
        self.prefetchDataSource = VPKTableViewPrefetchSynchronizer(videoItems: videoItems)
    }
}

protocol VPKPrefetchVideoDownloader: class {
    
    var videoItems: [VPKVideoType] { get set }
    var tasks: [URLSessionTask] { get set }
    
    func downloadVideo(forItemAtIndex index: Int)
    func cancelDownloadingVideo(forItemAtIndex index: Int)
}

public class VPKTableViewPrefetchSynchronizer: NSObject, VPKPrefetchVideoDownloader, UITableViewDataSourcePrefetching {
        
    var videoItems = [VPKVideoType]()
    var tasks = [URLSessionTask]()
    
    convenience public init(videoItems: [VPKVideoType]) {
        self.init()
        self.videoItems = videoItems
    }
    
    //MARK: Prefetch
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let filteredVideoItems = indexPaths.map{ self.videoItems[$0.row] }
        VPKVideoPlaybackManager.shared.preloadURLsForFeed(with: filteredVideoItems)
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        let filteredVideoItems = indexPaths.map{ self.videoItems[$0.row] }
        VPKVideoPlaybackManager.shared.cancelPreload(of: filteredVideoItems)
    }
    
    //MARK: Download
    func downloadVideo(forItemAtIndex index: Int) {
        
        //TODO: (SONAM)
        
        /*
         guard let url = videoItems[index].videoUrl else { return }
         guard tasks.index(where: { $0.originalRequest?.url == url }) == nil else {
         // We're already downloading the video.
         return
         }
         
         let resorceDelegate = VPKAssetResourceLoaderDelegate(customLoadingScheme: "VPKPlayback", resourcesDirectory: VPKVideoPlaybackManager.defaultDirectory, defaults: UserDefaults.standard)
         
         let asset = resorceDelegate.prefetchAssetData(for: url)
         
         //Configure asset, set resource delegate. Let resource delegate handle download.
         
         let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
         
         //download Video data on a background thread
         
         //Perform UI changes only on main thread.
         
         DispatchQueue.main.async {
         update UI If need be
         // Reload cell with fade animation.
         let indexPath = IndexPath(row: index, section: 0)
         if self.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
         self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
         }
         }
         }
         }
         task.resume()
         tasks.append(task)*/
        
    }
    
    func cancelDownloadingVideo(forItemAtIndex index: Int) {
        
        //TODO: (SONAM)
        
        /*guard let url = videoItems[index].videoUrl else { return }
         
         // Find a task with given URL, cancel it and delete from `tasks` array.
         guard let taskIndex = tasks.index(where: { $0.originalRequest?.url == url }) else { return }
         let task = tasks[taskIndex]
         task.cancel()
         tasks.remove(at: taskIndex)*/
    }
}
