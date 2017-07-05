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

    let datasource = Variable([
        VPKVideoType.local(videoPathName: "Elon_Musk", fileType: "mp4", placeholderImageName: "elon_1"),
        VPKVideoType.remote(url: "http://wbellentube-a.akamaihd.net/20160404/1656/0_t1zku1k4_0_6di1ulfi_2.mp4", placeholderURLName: "https://assets.ellentv.com/www.ellentv.com/main/default/img/ellen-og-1200x630.jpg"),
        VPKVideoType.remote(url: "http://wbellentube-a.akamaihd.net/20160404/1656/0_8x73t27s_0_hrxcpjv7_2.mp4", placeholderURLName: "http://media.ellentv.com/2016/04/05/john-travolta-talks-the-o-j-1362x1002-1.jpg"),
        VPKVideoType.remote(url: "http://wbellentube-a.akamaihd.net/20150603/1656/0_vmfukdeo_0_2tkvjd50_2.mp4", placeholderURLName: "http://media.ellentv.com/2015/06/04/a-exclusive-sneak-peek-at-the-magic-mikea-sequel-1362x1002.jpg")
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
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func setupTableView() {
        tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: VideoTableViewCell.identifier)
        
        datasource.asObservable().bind(to: tableView.rx.items(cellIdentifier: VideoTableViewCell.identifier)) { index, model, cell in
            guard let cell = cell as? VideoTableViewCell else { return }
            
            VPKVideoPlaybackBuilder.vpk_buildInFeedFor(model, atIndexPath:  NSIndexPath(item: index, section: 0), completion: { (videoView) in
                cell.videoView = videoView
                cell.layoutIfNeeded()
            })}.addDisposableTo(disposeBag)
        
        tableView.rx.setDelegate(self)
        
    }

}

extension FeedViewController: VPKTableViewVideoPlaybackScrollable {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
        return 440
    }
}
