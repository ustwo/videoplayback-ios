//
//  FeedViewController.swift
//  DemoVideoPlaybackKit
//
//  Created by Sonam on 5/11/17.
//  Copyright © 2017 ustwo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FeedViewController: UIViewController {

    var tableView = UITableView(frame: .zero)
    var shouldAutoplayVideos: Bool = false
    
    private let disposeBag = DisposeBag()
    fileprivate var videoPrefetcher: VPKTableViewPrefetchSynchronizer?

    
    let datasource = Variable([
        VPKVideoType.remote(url: "https://player.vimeo.com/external/211233094.hd.mp4?s=a96dcc4e1c9de0500061d674d9057c4b566220d9&profile_id=174", placeholderURLName: "https://usweb-cdn.ustwo.com/ustwo-production/uploads/2017/03/Ustwo-Final-2-640x320.jpg"),
        VPKVideoType.local(videoPathName: "Elon_Musk", fileType: "mp4", placeholderImageName: "elon_1"),
        VPKVideoType.remote(url: "https://player.vimeo.com/external/189642924.hd.mp4?s=79be91e8292d986c9a2c88b2548a882911ebfd8a&profile_id=174", placeholderURLName: "https://scontent-lga3-1.xx.fbcdn.net/v/t1.0-9/19424446_1546559992083662_6070232579525622322_n.jpg?oh=e0006b3c8964bf6f68c3e57a8f8e60f3&oe=5A34D122"),
        VPKVideoType.remote(url: "https://player.vimeo.com/external/210642044.hd.mp4?s=d5b146e3b9fb6ef7d7f4a95802d1c33bc9b3f0e9&profile_id=174", placeholderURLName: "https://usweb-cdn.ustwo.com/ustwo-production/uploads/2017/03/InHand_02-1800x1200.jpg"),
        VPKVideoType.remote(url: "https://player.vimeo.com/external/102607442.hd.mp4?s=e15ce96d2fa5f025d1e1bc401697f679bddf0fa9&profile_id=113", placeholderURLName: "https://usweb-cdn.ustwo.com/ustwo-production/uploads/2014/08/SimSpecs1.jpg")

    ])
    
    
    convenience init(_ autoPlay: Bool) {
        self.init()
        self.shouldAutoplayVideos = autoPlay
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
    }
    
    private func setup() {
        self.title = "Video Feed"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func setupTableView() {
        tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: VideoTableViewCell.identifier)
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.prefetchDataSource = self
        videoPrefetcher = VPKTableViewPrefetchSynchronizer(videoItems: datasource.value)
        
        datasource.asObservable().bind(to: tableView.rx.items(cellIdentifier: VideoTableViewCell.identifier)) { index, model, cell in
            guard let cell = cell as? VideoTableViewCell else { return }
            
            VPKVideoPlaybackBuilder.vpk_buildViewInCell(for: model, at: NSIndexPath(item: index, section: 0), completion: { (videoView) in
                cell.videoView = videoView
                cell.layoutIfNeeded()
            })}.addDisposableTo(disposeBag)
        
            tableView.rx.setDelegate(self)
        }

}

extension FeedViewController: VPKTableViewVideoPlaybackScrollable {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleAutoplayInTopVideoCell()
        trackVideoViewCellScrolling() // default implementation
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if shouldAutoplayVideos {
            handleAutoplayInTopVideoCell()
        }
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}


//* Use this delegate method to asynchronously load AVAsset keys in advance. This will help speed up progressive downloads of streams ** 

extension FeedViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    
        videoPrefetcher?.tableView(tableView, prefetchRowsAt: indexPaths)
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        videoPrefetcher?.tableView(tableView, cancelPrefetchingForRowsAt: indexPaths)
    }
}
