//
//  VPKTableViewPrefetchSynchronizer.swift
//  DemoVideoPlaybackKit
//s//  Created by Sonam on 7/5/17.
//  Copyright © 2017 ustwo. All rights reserved.
//


import Foundation
import UIKit

protocol VPKPrefetchVideoDownloader: class, UITableViewDataSourcePrefetching {
    var videoItems: [VPKVideoType] { get set }
    var tasks: [URLSessionTask] { get set }

    func downloadVideo(forItemAtIndex index: Int)
    func cancelDownloadingVideo(forItemAtIndex index: Int)
}

class VPKTableViewPrefetchSynchronizer: NSObject, VPKPrefetchVideoDownloader {

    
    var videoItems = [VPKVideoType]()
    var tasks = [URLSessionTask]()

    convenience init(videoItems: [VPKVideoType]) {
        self.init()
        self.videoItems = videoItems
    }
    
    //MARK: Prefetch 
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { downloadVideo(forItemAtIndex: $0.row) }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { cancelDownloadingVideo(forItemAtIndex: $0.row) }
    }
    
    //MARK: Download
    func downloadVideo(forItemAtIndex index: Int) {
        guard let url = videoItems[index].videoUrl else { return }
        
        guard tasks.index(where: { $0.originalRequest?.url == url }) == nil else {
            // We're already downloading the video.
            return
        }
        
        let resorceDelegate = VPKAssetResourceLoaderDelegate(customLoadingScheme: "VPKPlayback", resourcesDirectory: VPKVideoPlaybackManager.defaultDirectory, defaults: UserDefaults.standard)
        
        let asset = resorceDelegate.prepareAsset(for: url)
        
        //Configure asset, set resource delegate. Let resource delegate handle download.
        
       /* let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            //download Video data on a background thread 
            
            // Perform UI changes only on main thread.
            
            DispatchQueue.main.async {
                //update UI If need be 
//                    // Reload cell with fade animation.
//                    let indexPath = IndexPath(row: index, section: 0)
//                    if self.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
//                        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
//                    }
//                }
            }
        }
        task.resume()
        tasks.append(task)*/
    }
    
    func cancelDownloadingVideo(forItemAtIndex index: Int) {
        guard let url = videoItems[index].videoUrl else { return }
        
        // Find a task with given URL, cancel it and delete from `tasks` array.
        guard let taskIndex = tasks.index(where: { $0.originalRequest?.url == url }) else { return }
        let task = tasks[taskIndex]
        task.cancel()
        tasks.remove(at: taskIndex)
    }
}
